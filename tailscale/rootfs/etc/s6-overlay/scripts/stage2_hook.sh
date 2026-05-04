#!/command/with-contenv bashio
# shellcheck shell=bash
export LOG_FD
# ==============================================================================
# Home Assistant Community App: Tailscale
# S6 Overlay stage2 hook to customize services
# ==============================================================================

source /usr/lib/api.core.sh

declare options
declare proxy funnel proxy_and_funnel_port
declare healthcheck_offline_timeout healthcheck_restart_timeout
declare forward_to_host
declare advertise_routes
declare tags
declare ssh
declare share_service_name

readonly MAGIC_DNS_IPV4="100.100.100.100"
readonly MAGIC_DNS_IPV6="fd7a:115c:a1e0::53"
declare dns
declare invalid_dns_config
declare message
declare -a messages=()
declare attributes

# Add timestamp to plain stdout and stderr messages
exec &> >(ts "${__BASHIO_LOG_TIMESTAMP} $(basename $0 .sh):" > /proc/1/fd/1)

# This is to execute potentially failing supervisor api functions within conditions,
# where set -e is not propagated inside the function and bashio relies on set -e for api error handling
function try {
    set +e
    (set -e; "$@")
    declare -gx TRY_ERROR=$?
    set -e
}

# Load app options, even deprecated one to upgrade
options=$(bashio::addon.options)

# Upgrade configuration from 'proxy', 'funnel' and 'proxy_and_funnel_port' to 'share_homeassistant' and 'share_on_port'
# This step can be removed in a later version
proxy=$(bashio::jq "${options}" '.proxy | select(.!=null)')
funnel=$(bashio::jq "${options}" '.funnel | select(.!=null)')
proxy_and_funnel_port=$(bashio::jq "${options}" '.proxy_and_funnel_port | select(.!=null)')
# Upgrade to share_homeassistant
if bashio::var.true "${proxy}"; then
    if bashio::var.true "${funnel}"; then
        bashio::addon.option 'share_homeassistant' 'funnel'
        bashio::log.info "Successfully migrated proxy and funnel options to share_homeassistant: funnel"
    else
        bashio::addon.option 'share_homeassistant' 'serve'
        bashio::log.info "Successfully migrated proxy and funnel options to share_homeassistant: serve"
    fi
fi
# Upgrade to share_on_port
if bashio::var.has_value "${proxy_and_funnel_port}"; then
    try bashio::addon.option 'share_on_port' "^${proxy_and_funnel_port}"
    if ((TRY_ERROR)); then
        bashio::log.warning "The proxy_and_funnel_port option value '${proxy_and_funnel_port}' is invalid, proxy_and_funnel_port option is dropped, using default port."
    else
        bashio::log.info "Successfully migrated proxy_and_funnel_port option to share_on_port: ${proxy_and_funnel_port}"
    fi
fi
# Remove previous options
if bashio::var.has_value "${proxy}"; then
    bashio::log.info 'Removing deprecated proxy option'
    bashio::addon.option 'proxy'
fi
if bashio::var.has_value "${funnel}"; then
    bashio::log.info 'Removing deprecated funnel option'
    bashio::addon.option 'funnel'
fi
if bashio::var.has_value "${proxy_and_funnel_port}"; then
    bashio::log.info 'Removing deprecated proxy_and_funnel_port option'
    bashio::addon.option 'proxy_and_funnel_port'
fi

# Remove unused options
healthcheck_offline_timeout=$(bashio::jq "${options}" '.healthcheck_offline_timeout | select(.!=null)')
healthcheck_restart_timeout=$(bashio::jq "${options}" '.healthcheck_restart_timeout | select(.!=null)')
forward_to_host=$(bashio::jq "${options}" '.forward_to_host | select(.!=null)')
if bashio::var.has_value "${healthcheck_offline_timeout}"; then
    bashio::log.info 'Removing deprecated healthcheck_offline_timeout option'
    bashio::addon.option 'healthcheck_offline_timeout'
fi
if bashio::var.has_value "${healthcheck_restart_timeout}"; then
    bashio::log.info 'Removing deprecated healthcheck_restart_timeout option'
    bashio::addon.option 'healthcheck_restart_timeout'
fi
if bashio::var.has_value "${forward_to_host}"; then
    bashio::log.info 'Removing deprecated forward_to_host option'
    bashio::addon.option 'forward_to_host'
fi

# Update changed options
advertise_routes=$(bashio::jq "${options}" '.advertise_routes | select(.!=null)')
if bashio::var.has_value "${advertise_routes}" && \
    bashio::jq.has_value "${advertise_routes}" '.[] | select(.|match("^local[^_]subnets$"))'
then
    bashio::log.info 'Updating advertise_routes option to match new schema'
    advertise_routes=$(bashio::jq "${advertise_routes}" '(.[] | select(.|match("^local[^_]subnets$"))) |= "local_subnets"')
    bashio::addon.option 'advertise_routes' "^${advertise_routes}"
fi

# Rename changed options
tags=$(bashio::jq "${options}" '.tags | select(.!=null)')
if bashio::var.has_value "${tags}"; then
    try bashio::addon.option 'advertise_tags' "^${tags}"
    if ((TRY_ERROR)); then
        bashio::log.warning "The tags option value is invalid, tags option is dropped, using default no advertise_tags."
        bashio::log.warning "The invalid tags option value is: '${tags}'"
    else
        bashio::log.info "Successfully renamed tags option to advertise_tags"
    fi
    bashio::addon.option 'tags'
fi

# Migrate ssh to tailscale_ssh.enabled
ssh=$(bashio::jq "${options}" '.ssh | select(.!=null)')
if bashio::var.has_value "${ssh}"; then
    try bashio::addon.option 'tailscale_ssh.enabled' "^${ssh}"
    if ((TRY_ERROR)); then
        bashio::log.warning "The ssh option migration failed, ssh option '${ssh}' is dropped, using default disabled."
    else
        bashio::log.info "Successfully migrated ssh option to tailscale_ssh.enabled"
    fi
    bashio::addon.option 'ssh'
fi

# Disable init-packages service when tailscale_ssh.enabled is false
# or no packages and no init_commands are defined
if bashio::config.false 'tailscale_ssh.enabled' || \
    (! bashio::config.has_value 'tailscale_ssh.packages' && \
    ! bashio::config.has_value 'tailscale_ssh.init_commands')
then
    rm /etc/s6-overlay/s6-rc.d/tailscaled/dependencies.d/init-packages
fi

# Remove deprecated share_service_name option
share_service_name=$(bashio::jq "${options}" '.share_service_name | select(.!=null)')
if bashio::var.has_value "${share_service_name}"; then
    bashio::log.info 'Removing deprecated share_service_name option'
    bashio::addon.option 'share_service_name'
fi

# Check DNS configuration
# This is identical with the check in init-magicdns-proxies/run
# This check is to modify the configuration to prevent the check in init-magicdns-proxies/run from stopping the app startup
invalid_dns_config="false"
for dns in $(bashio::dns.locals); do
    if bashio::var.equals "${dns}" "dns://${MAGIC_DNS_IPV4}" || \
        bashio::var.equals "${dns}" "dns://${MAGIC_DNS_IPV6}"
    then
        message="Do not configure MagicDNS's IP address (${dns:6}) as DNS server under Settings -> System -> Network"
        messages+=("**${message}!**")
        bashio::log.warning "${message}"
        invalid_dns_config="true"
    fi
done
if bashio::var.true "${invalid_dns_config}"; then
    bashio::log.warning \
        "Due to invalid networking DNS configuration, userspace_networking option will be enabled to disable MagicDNS"
    bashio::log.warning \
        "Please check your configuration based on the app's documentation under the \"DNS\" section"
    bashio::log.warning \
        "After the issue is fixed you can disable userspace_networking option again and restart the app"

    # Create persistent notification also
    attributes=$(bashio::var.json \
        title "Tailscale App" \
        message "$(printf "%s\n\n" \
            "${messages[@]}" \
            "Due to invalid networking DNS configuration, \`userspace_networking\` option will be enabled to disable MagicDNS." \
            "**Refresh Home Assistant's UI (web page) to reflect the configuration change!**" \
            "Please check your configuration based on the app's documentation under the \"DNS\" section." \
            "After the issue is fixed you can disable \`userspace_networking\` option again and restart the app.")")
    if ! api.core POST services/persistent_notification/create "${attributes}" -w > /dev/null; then
        bashio::log.warning \
            "Failed to create persistent notification"
    fi

    bashio::addon.option 'userspace_networking' 'true'
fi

# MagicDNS related service dependencies:
#
#   user
#   |  ˅
#   |  magicdns-proxies-reconfigurator
#   ˅  ˅
#   magicdns-ingress-proxy
#   |  ˅
#   |  magicdns-proxies-configurator
#   |  ˅
#   |  post-tailscaled
#   |  ˅
#   |  tailscaled
#   |  ˅
#   |  magicdns-egress-proxy
#   ˅  ˅
#   init-magicdns-proxies
#
if bashio::config.true "userspace_networking"; then
    # Disable MagicDNS egress and ingress proxy related services when userspace_networking is enabled
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/magicdns-proxies-reconfigurator
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/magicdns-ingress-proxy
    rm /etc/s6-overlay/s6-rc.d/tailscaled/dependencies.d/magicdns-egress-proxy
elif bashio::config.false "accept_dns"; then
    # Disable MagicDNS egress and ingress proxy reconfigurator when userspace_networking is disabled but accept_dns is also disabled
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/magicdns-proxies-reconfigurator
fi

# Disable protect-subnets service when userspace-networking is enabled or accepting routes is disabled
if bashio::config.true "userspace_networking" || \
    bashio::config.false "accept_routes";
then
    rm /etc/s6-overlay/s6-rc.d/post-tailscaled/dependencies.d/protect-subnets
fi

# If local subnets are not configured in advertise_routes, do not wait for the local network to be ready to collect subnet information
if ! bashio::config "advertise_routes" | grep -Fxq "local_subnets"; then
    rm /etc/s6-overlay/s6-rc.d/post-tailscaled/dependencies.d/local-network
fi

# Disable forwarding service when userspace-networking is enabled
if bashio::config.true "userspace_networking"; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/forwarding
fi

# Disable mss-clamping service when userspace-networking is enabled
if bashio::config.true "userspace_networking"; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/mss-clamping
fi

# Disable taildrop service when it has been explicitly disabled
if bashio::config.false 'taildrop'; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/taildrop
fi

# Disable share-homeassistant service when it has been explicitly disabled
if bashio::config.equals 'share_homeassistant' 'disabled'; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/share-homeassistant
fi

# Disable certificate service when it has not been configured
if bashio::config.equals 'share_homeassistant' 'disabled' || \
    ! bashio::config.has_value 'lets_encrypt_certfile' || \
    ! bashio::config.has_value 'lets_encrypt_keyfile';
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/certificate
fi

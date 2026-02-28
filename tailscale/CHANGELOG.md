# Changelog

## vNext (forked)

- Bugfix for MagicDNS: do not log SERVFAIL caused by Supervisor's hourly tests
- For supervised installations add networking rules to apparmor.txt
- Merge released changes from community app
  - Drop support for armv7 architecture
  - Update Add-on base image to v20 (drop armv7 support)

## 0.27.1.1 (forked)

- Add new options for Tailscale SSH: packages and init_commands ([@sim-san](https://github.com/sim-san))
- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.94.2
  - Make service name option configurable for Share Home Assistant option
- Merge released changes from community app
  - Refactoring and renaming add-ons to apps

## 0.26.1.11 (forked)

- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.94.1

## 0.26.1.10 (forked)

- Bugfix for previous MagicDNS incompatibility fix (prevent logging SERVFAIL lines when accept_dns is disabled)
- Bugfix for Taildrive (prevent logging anything when no share is configured)
- Release pending changes from community app
  - Create persistent notification also (not just log warning) when key expiration is detected
  - Make advertise_connector, advertise_exit_node, advertise_routes, taildrop and userspace_networking options default disabled to align with stock Tailscale's platform-specific behavior
  - Rename tags option to advertise_tags to align with stock Tailscale's naming convention - ***config is automatically updated***

## 0.26.1.9 (forked)

- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.92.5

## 0.26.1.8 (forked)

- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.92.3

## 0.26.1.7 (forked)

- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.92.1

## 0.26.1.6 (forked)

- Release pending changes from community app
  - Make always use derp option configurable (fixes [569](https://github.com/hassio-addons/app-tailscale/issues/569))

## 0.26.1.5 (forked)

- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.90.9

## 0.26.1.4 (forked)

- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.90.8
  - Remove deprecated codenotary fields
- Release pending changes from community app
  - Make accept_routes default disabled to align with stock Tailscale's platform-specific behavior
- Withhold changes from community app (will be released here later)
  - Drop support for armv7 architecture
  - Update App base image to v19 (drop armv7 support)

## 0.26.1.3 (forked)

- Release pending changes from community app
  - ***CRITICAL*** Workaround for app base image and bashio bug that causes apps to crash when debug level logging is enabled

## 0.26.1.2 (forked)

- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.90.6
  - Update App base image to v18.2.1

## 0.26.1.1 (forked)

- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.88.3

## 0.26.0.1 (forked)

- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.88.1
- Merge released changes from community app
  - Update App base image to v18.1.1

## 0.25.0.12 (forked)

- Fix: create certificate file directories for lets_encrypt_certfile and lets_encrypt_keyfile if they don't exists already
- Release unreleased changes from community app
  - Update App base image to v18.1.0

## 0.25.0.11 (forked)

- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.86.2

## 0.25.0.10 (forked)

- Make Tailscale SSH configurable

## 0.25.0.9 (forked)

- Fix Taildrive breaking startup

## 0.25.0.8 (forked)

- Fix config migration script (merge proxy and funnel options into share_homeassistant)

## 0.25.0.7 (forked)

***BREAKING CHANGES:***
- Fix DNS documentation
- Check DNS configuration

  Before upgrade :
  1. Check that under **Settings** -> **System** -> **Network** Tailscale's DNS is
     ***not*** configured as DNS server.
  1. In the command line execute `ha dns options --servers dns://100.100.100.100`.

     **Note:** _This command replaces the existing DNS server list in Home
     Assistant and restarts the internal DNS server. To specify an empty DNS list
     (i.e. to remove `dns://100.100.100.100` from the list), you must use
     `ha dns reset` and `ha dns restart` commands both. This server list is
     additional and queried before the DNS servers specified in Network settings
     above._

  This is required for the Supervisor to not lose name resolution and network connectivity.

Nonbreaking changes:
- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.86.0
  - Update App base image to v18.0.3 (Update Alpine base image to v3.22.0)
- Release pending changes from community app:
  - Merge proxy and funnel options into share_homeassistant, rename proxy_and_funnel_port to share_on_port - ***config is automatically updated***
  - Make all config options mandatory, fill in the default values for previously optional config options
  - Add support for Taildrive (from PR [#509](https://github.com/hassio-addons/app-tailscale/pull/509) by [@ananthb](https://github.com/ananthb))
  - Make exit-node configurable

## 0.25.0.6 (forked)

- Fix: letsencrypt's api dns resolution for serve certificate generation (bugfix in the solution for MagicDNS incompatibility with Home Assistant)
- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.84.0

## 0.25.0.5 (forked)

- Fix: Skip DHCP lease renewal if nothing has changed (subnet protection)
- Fix: Do not fail if local network is down on startup (healthcheck)
- Release unreleased changes from community app
  - Update App base image to v17.2.5
- Release pending changes from community app:
  - Wait for local network on startup
  - Remove duplicated service dependencies

## 0.25.0.4 (forked)

- Fix dnsmasq startup race condition (that caused high CPU load)

## 0.25.0.3 (forked)

***BREAKING CHANGES:***
- Remove healthcheck_offline_timeout and healthcheck_restart_timeout options, hardwire 5 minutes and 1 hour (because they are removed during review in the official app)
- Remove forward_to_host option, always enabled from now on (because this is removed during review in the official app)

Nonbreaking changes:
- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.82.5
  - Update App base image to v17.2.4

## 0.25.0.2 (forked)

- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.82.0
  - Update App base image to v17.2.2

## 0.25.0.1 (forked)

- Release unreleased changes from community app
  - Update tailscale/tailscale to v1.80.3
- Merge released changes from community app
  - Update App base image to v17.2.1

## 0.24.0.3 (forked)

- Fix: Warn when there's no default interface on the host to forward incoming tailnet connections to
- Fix: Properly remove DSCP setting from iptables
- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.80.2
  - Update App base image to v17.1.5

## 0.24.0.2 (forked)

- Bugfix previous MagicDNS incompatibility fix (for Headscale users)
- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.80.0

## 0.24.0.1 (forked)

- Fix MagicDNS incompatibility with Home Assistant
- Forward incoming tailnet connections to the host's primary interface
- Fix MSS clamping for site-to-site networking
- Merge unreleased changes from community app
  - Update App base image to v17.1.0 (Update Alpine base image to v3.21)

## 0.23.3.1 (forked)

- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.78.1

## 0.23.2.1 (forked)

***BREAKING CHANGES:***
- Rename healthcheck_timeout to healthcheck_offline_timeout

Nonbreaking changes:
- Experimental
  - Make HEALTHCHECK restart timeout configurable
- Merge released changes from community app
  - Update tailscale/tailscale to v1.76.6
- Merge unreleased changes from community app
  - Update App base image to v16.3.6
- Release unmerged changes from community app
  - Configure log format for the app to be compatible with Tailscale's format

## 0.23.1.1 (forked)

- Experimental
  - Make HEALTHCHECK offline timeout configurable
  - Make DSCP configurable on tailscaled's network traffic
- Merge unreleased changes from community app
  - Fix subnet protection when connectivity state is not 'full'
  - Update App base image to v16.3.4
- Merge released changes from community app
  - Update tailscale/tailscale to v1.76.1

## 0.22.1.1 (forked)

- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.76.0

## 0.22.1.0 (forked)

- Merge released changes from community app
  - Update App base image to v16.3.2

## 0.21.0.3 (forked)

- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.74.1

## 0.21.0.2 (forked)

- Experimental
  - Add HEALTHCHECK support
- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.74.0
  - Update App base image to v16.3.1

## 0.21.0.1 (forked)

***BREAKING CHANGES:***
- Refactor UDP port into Network config option

Nonbreaking changes:
- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.72.1
  - Update App base image to v16.2.1

## 0.20.0.3 (forked)

- Make UDP port configurable
- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.70.0
  - Update App base image to v16.1.3

## 0.20.0.2 (forked)

- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.68.2
  - Update App base image to v16.1.2

## 0.20.0.1 (forked)

- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.68.1

## 0.20.0.0 (forked)

- Merge released changes from community app
  - Update App base image to v16.0.1

## 0.19.1.2 (forked)

- Merge unreleased changes from community app
  - Failsafe enabling of UDP GRO for forwarding
  - Update App base image to v16.0.0 (Update Alpine base image to v3.20.0)

## 0.19.1.1 (forked)

- Merge unreleased changes from community app
  - Revert "Linux optimizations for subnet routers and exit nodes"

## 0.19.0.1 (forked)

- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.66.4
  - Stateful filtering is now off by default
  - Skip default networks without a gateway to enable UDP GRO for forwarding
  - Update App base image to v15.0.9

## 0.18.0.6 (forked)

- Merge unreleased changes from community app
  - Allow Linux optimizations (UDP GRO for forwarding) on multiple interfaces and IPv6

## 0.18.0.5 (forked)

- Merge unreleased changes from community app
  - Add app connector option
  - Fix Linux optimizations

## 0.18.0.4 (forked)

- Make stateful-filtering configurable (disable it, if you previously configured eg. site-to-site networking on some level: ie. enabled your non-tailscale devices in a routed subnet to initiate traffic toward your tailnet (other tailnet nodes, or other subnets))

## 0.18.0.3 (forked)

- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.66.3

## 0.18.0.2 (forked)

- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.66.1

## 0.18.0.1 (forked)

- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.66.0
  - Linux optimizations for subnet routers and exit nodes ([details](https://tailscale.com/kb/1320/performance-best-practices#linux-optimizations-for-subnet-routers-and-exit-nodes))

## 0.17.0.2 (forked)

- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.64.0

## 0.17.0.1 (forked)

- Merge unreleased changes from community app
  - Fix tag name validation regex
  - Update App base image to v15.0.8

## 0.17.0.0 (forked)

- Merge released changes from community app
  - Update tailscale/tailscale to v1.62.1

## 0.16.1.1 (forked)

- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.62.0

## 0.16.0.1 (forked)

- Merge unreleased changes from community app
  - Update tailscale/tailscale to v1.60.1

## 0.16.0.0 (forked)

- Merge released changes from community app
  - Update tailscale/tailscale to v1.60.0
  - Use readonly webui mode in v1.60.0
  - Update App base image to v15.0.7

## 0.15.0.1 (forked)

- Drop kernel configuration access (really fixes [#325](https://github.com/hassio-addons/app-tailscale/issues/325))

## 0.14.0.1 (forked)

***Note: Do not use the Tailscale web UI to modify `advertise_exit_node` and `advertise_routes` settings, the next restart of the app will overwrite those changes. Soon a locked read-only web UI option will be released by Tailscale to address this issue (see [#10999](https://github.com/tailscale/tailscale/pull/10999)).***

- Merge unreleased changes from community app
  - Fix kernel configuration access for Debian Supervised installations (fixes [#325](https://github.com/hassio-addons/app-tailscale/issues/325))
  - Update tailscale/tailscale to v1.58.2
  - Update App base image to v15.0.6

## 0.14.0.0 (forked)

This version is basically equivalent with the 0.14.0 community app version. Only remaining additional functionality:
- Optionally copy Tailscale Proxy's certificate files to /ssl folder

***BREAKING CHANGES:***
- Configuring Tailscale Proxy and Funnel port from now on is done by the `proxy_and_funnel_port` app config option and not by the networking host port configuration section. This is the accepted and merged solution for this issue.

Nonbreaking changes:
- Merge released changes from original app
  - Increase wait time for Supervisor
  - Wait for HA to be available during startup
  - Update App base image to v15.0.3

## 0.13.1.7 (forked)

***BREAKING CHANGES:***
- Remove: Advanced Tailscale Proxy and Funnel configuration - ie. advanced_config option (after the app doesn't reset serve config, manual configuration will not interfere with it)

Nonbreaking changes:
- Merge funnel and proxy services into longrun serve service, drop internal serve config reset
- Merge unreleased changes from original app
  - Update tailscale/tailscale to v1.56.1

## 0.13.1.6 (forked)

- Fix: Clamping the MSS for IPv6 also
- Fix: Certificate export log message
- Merge unreleased changes from original app
  - Update tailscale/tailscale to v1.56.0
  - Update App base image to v15.0.1 (Update Alpine base image to v3.19.0)

## 0.13.1.5 (forked)

***BREAKING CHANGES:***
- Remove: Make auth-key configurable

Nonbreaking changes:
- Fix certificate copy on first startup
- Merge unreleased changes from original app
  - Update tailscale/tailscale to v1.54.1

## 0.13.1.4 (forked)

- Merge unreleased changes from original app
  - Update tailscale/tailscale to v1.54.0
  - Update App base image to v14.3.2

## 0.13.1.3 (forked)

- Advanced Tailscale Proxy and Funnel configuration
- Fix certificate export: Do not swallow real error messages from inotifywait
- Fix certificate export: Do not fail on first startup if certs dir doesn't exist

## 0.13.1.2 (forked)

- Merge unreleased changes from original app
  - Update tailscale/tailscale to v1.52.1

## 0.13.1.1 (forked)

- Use modified tailscale cli arguments for serve and funnel
- Merge unreleased changes from original app
  - Update tailscale/tailscale to v1.52.0

## 0.13.1.0 (forked)

- Merge changes from original app
  - Update App base image to v14.3.1

## 0.13.0.1 (forked)

***BREAKING CHANGES:***
- Drop support for armhf & i386, because this is dropped from the original app repo also

Nonbreaking changes:
- Bugfix: Test Home Assistant's HTTP reverse proxy configuration on app start _only when Home Assistant is running_
- Merge changes from original app
  - Sync all details of the merged and unmerged PRs
  - Update App base image to v14.3.0

## 0.12.0.1 (forked)

***BREAKING CHANGES:***
- Proxy and Funnel is disabled by default, because this got to be the default in the original app.
  **If you previously used the default settings, enable them explicitly before installing this update:**
  ```
  funnel: true
  proxy: true
  ```

Nonbreaking changes:
- New: Make Tailscale Proxy and Funnel port configurable
- New: Make auth-key configurable (inspired by [@laenbdarceq](https://github.com/laenbdarceq))
- New: Optionally copy Tailscale Proxy's certificate files to /ssl folder
- Bugfix: Really disable Tailscale Proxy and Funnel when they are disabled
- Bugfix: Always protect the _local_ subnets (not the configurable _advertised_ subnets) from collision
- Merge changes from original app
  - Sync all details of the merged and unmerged PRs
  - Update App base image to v14.2.2

## 0.11.1.26 (forked)

- Warn when userspace networking is used to turn it off to access other clients on the tailnet
- Merge (unreleased) changes from original app
  - Update tailscale/tailscale to v1.50.1
  - Update App base image to v14.2.0

## 0.11.1.25 (forked)

- Use new v1.50.0 .Self.CapMap in status json for https proxy and funnel support check
- Merge (unreleased) changes from original app
  - Update tailscale/tailscale to v1.50.0

## 0.11.1.24 (forked)

- Detect kernel support for MSS clamping and skip it if not supported (workaround for HA OS Odroid N2)
- Merge (unreleased) changes from original app
  - Update App base image to v14.1.1

## 0.11.1.23 (forked)

- Merge (unreleased) changes from original app
  - Update tailscale/tailscale to v1.48.2

## 0.11.1.22 (forked)

- Warn about key expiration on app startup

## 0.11.1.21 (forked)

- Properly test Home Assistant's HTTP reverse proxy configuration (especially test `use_x_forwarded_for` settings)

  ***IMPORTANT: Read proxy documentation before updating, this update can cause the app to not start, it can be a breaking change! If you don't use proxy functinality, disable it before installing this update!***

## 0.11.1.20 (forked)

- Make accepting subnet routes configurable (from PR [#252](https://github.com/hassio-addons/app-tailscale/pull/252) by [@willnorris](https://github.com/willnorris))

## 0.11.1.19 (forked)

- Merge (unreleased) changes from original app
  - Update tailscale/tailscale to v1.48.1

## 0.11.1.18 (forked)

- Handle previous non-graceful stop of app
- Merge (unreleased) changes from original app
  - Update tailscale/tailscale to v1.48.0

## 0.11.1.17 (forked)

- Re-add: Test HTTPS proxy configuration on startup
- Remove: Allow proxy connection to HTTPS Home Assistant instance with insecure HTTPS proxying

## 0.11.1.16 (forked)

- Remove HTTPS proxy configuration testing

## 0.11.1.15 (forked)

- Bugfix: fix HTTPS proxy configuration testing wait loop with increased timeout

## 0.11.1.14 (forked)

- Bugfix: fix HTTPS proxy configuration testing with wait loop

## 0.11.1.13 (forked)

- Test HTTPS proxy configuration on startup
- Protect against "System is not ready with state: setup" supervisor errors
- Merge (unreleased) changes from original app
  - Update App base image to v14.1.0 (Update Alpine base image to v3.18.3)

## 0.11.1.12 (forked)

- Merge (unreleased) changes from original app
  - Update App base image to v14.0.7

## 0.11.1.11 (forked)

- Make advertised subnet routes configurable
- Fix issue [#43](https://github.com/lmagyar/homeassistant-addon-tailscale/issues/43) (HA OS VM IPv6 multiple routing tables are not enabled)
- Allow proxy connection to HTTPS Home Assistant instance with insecure HTTPS proxying
- Reset proxy configuration on startup
- Merge (unreleased) changes from original app
  - Update tailscale/tailscale to v1.46.1
  - Update App base image to v14.0.6

## 0.11.1.10 (forked)

- Make subnet source NAT configurable (to support advanced site-to-site networking)
- Clamp the MSS to the MTU for all advertised subnet's interface (to support site-to-site networking better)
- Fix local subnet collision protection (to protect even when the network is reconfigured)

## 0.11.1.9 (forked)

- Sign app with Sigstore Cosign
- Merge (unreleased) changes from original app
  - Update tailscale/tailscale to v1.44.0
  - Update App base image to v14.0.2

## 0.11.1.8 (forked)

- Do not opt out of client log upload in debug log level (fixes [#211](https://github.com/hassio-addons/app-tailscale/issues/211))
- Create fallback page for iOS browsers failing to open Tailscale login page (from PR [#198](https://github.com/hassio-addons/app-tailscale/pull/198) by [@bitfliq](https://github.com/bitfliq))

## 0.11.1.7 (forked)

- Fix ip rule manipulation for IPv6 (in case of non-userspace networking and colliding subnets)
- Merge (unreleased) changes from original app
  - Update tailscale/tailscale to v1.42.0

## 0.11.1.6 (forked)

- Notify about colliding subnet routes
- Merge (unreleased) changes from original app
  - Update App base image to v14 (Update Alpine base image to v3.18.0)

## 0.11.1.5 (forked)

- Merge (unreleased) changes from original app
  - Update tailscale/tailscale to v1.40.1

## 0.11.1.4 (forked)

- Protect local subnets from being routed toward Tailscale subnets if they collide

## 0.11.1.3 (forked)

- Make userspace networking configurable

## 0.11.1.2 (forked)

- Merge (unreleased) changes from original app
  - Enable Tailscale's builtin inbound HTTPS proxy
  - Drop userspace networking
  - Make accepting magicDNS optional

## 0.11.1.1 (forked)

- Make Proxy and Funnel configurable
- Remove Tailscale's SOCKS5 and HTTP outbound proxy (not needed after userspace networking is dropped)
- Merge (unreleased) changes from original app
  - Update tailscale/tailscale to v1.40.0
  - Make Taildrop configurable
  - Make exit node advertisement configurable
  - Add custom control server support
  - Update App base image to v13.2.2

## 0.10.1.3 (forked)

- Put local UI webserver on to different port than original app's

## 0.10.1.2 (forked)

- Bugfix for login server config

## 0.10.1.1 (forked)

- Allow customizing the login server (from PR [#175](https://github.com/hassio-addons/app-tailscale/pull/175) by [@reey](https://github.com/reey))
- Merge changes from original app
  - Update tailscale/tailscale to v1.38.4

## 0.10.0.1 (forked)

- Remove ACL tagging recommendation from Funnel documentation, finally `autogroup:members` works
- Merge changes from original app
  - Add support for Taildrop

## 0.9.0.6 (forked)

- Use the default app network config UI for SOCKS5 and HTTP outbound proxy port configuration

## 0.9.0.5 (forked)

- Remove duplicate status checks from dependent S6 services

## 0.9.0.4 (forked)

- Remove unneeded app privileges

## 0.9.0.3 (forked)

- Enable Tailscale's Funnel feature

## 0.9.0.2 (forked)

- Enable Tailscale's SOCKS5 and HTTP outbound proxy

## 0.9.0.1 (forked)

- Move Tailscale Proxy functionality into standalone oneshot S6 service
- Merge changes from original app
  - Advertise all supported interfaces as Tailscale Subnets
  - Suppress tailscaled logs after 200 lines
  - Bump Tailscale to 1.38.3
  - Bump base image to 13.2.0

## 0.8.0.1 (forked)

- Merge PR modifications
- Merge changes from original app
  - Migrate old-style S6 scripts to s6-rc.d
  - Bump base image to 13.1.4

## 0.7.0.13 (forked)

- Bump Tailscale to 1.38.2

## 0.7.0.12 (forked)

- Bump Tailscale to 1.38.1
- Bump base image to 13.1.3

## ~~0.7.0.11 (forked)~~

_This version number is skipped, just to be in sync with the [Funnel version repo](https://github.com/lmagyar/homeassistant-addon-tailscale-funnel)._

## 0.7.0.10 (forked)

- Bump Tailscale to 1.36.2
- Bump base image to 13.1.2

## 0.7.0.9 (forked)

- Bump Tailscale to 1.36.1

## 0.7.0.8 (forked)

***Breaking change***

- Enable Tailscale's Proxy feature
- Revert explicit TLS certificate provisioning

## 0.7.0.7 (forked)

- Use `log_level` configuration option for tailscaled debug messages

## 0.7.0.6 (forked)

- Bump Tailscale to 1.36.0
- Bump base image to 13.1.1

## 0.7.0.5 (forked)

- Only optionally enable tailscaled debug messages in the app's log

## 0.7.0.4 (forked)

- Bump base image to 13.1.0

## 0.7.0.3 (forked)

- Advertise all supported interfaces as Subnets

## 0.7.0.2 (forked)

- Rename TLS certificates configuration option from `cert_domain` to `certificate_tailnet_name`

## 0.7.0.1 (forked)

- Enables to provision TLS certificates
- Bump Tailscale to 1.34.2
- Bump base image to 13.0.1

## 0.7.0.0 (forked)

- Fork of the original v0.7.0

For previous changelog see the original app's [release history](https://github.com/hassio-addons/app-tailscale/releases).

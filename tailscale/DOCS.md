# Home Assistant Custom App: Tailscale with features

![Warning][warning_stripe]

> This is a **fork** of the [community app][community_app]!
>
> Changes:
> - Release unreleased changes from community app
>   - Update tailscale/tailscale to v1.94.2
>   - Fix MagicDNS incompatibility with Home Assistant
>   - Make all config options mandatory, fill in the default values for previously optional config options
>   - Add support for Taildrive
>   - Make always use derp option configurable
>   - Make service name option configurable for Share Home Assistant option
> - Release pending changes from community app
>   - Make accept_routes, advertise_connector, advertise_exit_node, advertise_routes, taildrop and userspace_networking options default disabled to align with stock Tailscale's platform-specific behavior
>   - Rename tags option to advertise_tags to align with stock Tailscale's naming convention - ***config is automatically updated***
> - Release unmerged changes from community app
>   - Make Tailscale SSH configurable
>   - Create persistent notification also (not just log warning) when key expiration is detected
>   - Optionally copy Tailscale Serve's certificate files to /ssl folder
>   - Make DSCP configurable on tailscaled's network traffic
>   - Configure log format for the app to be compatible with Tailscale's format

![Warning][warning_stripe]

Tailscale is a zero config VPN, which installs on any device in minutes,
including your Home Assistant instance.

Create a secure network between your servers, computers, and cloud instances.
Even when separated by firewalls or subnets, Tailscale just works. Tailscale
manages firewall rules for you, and works from anywhere you are.

## Prerequisites

In order to use this app, you'll need a Tailscale account.

It is free to use for personal & hobby projects, up to 100 clients/devices on a
single user account. Sign up using your Google, Microsoft or GitHub account at
the following URL:

<https://login.tailscale.com/start>

You can also create an account during the app installation processes,
however, it is nice to know where you need to go later on.

## Installation

1. In Home Assistant, go to **Settings** -> **Apps** -> **Install app**.
1. In the **...** menu at the top right corner click **Repositories**, add
   `https://github.com/lmagyar/homeassistant-addon-tailscale` as repository.
1. Find the "Tailscale with features" app and click it. If it doesn't show
   up, wait until HA refreshes the information about the app, or click
   **Check for updates** in the **...** menu at the top right corner.
1. Click the "INSTALL" button.

## How to use

1. Start the "Tailscale with features" app.
1. Check the logs of the "Tailscale with features" app to see if everything
   went well.
1. Open the **Web UI** of the "Tailscale with features" app to complete
   authentication and couple your Home Assistant instance with your Tailscale
   account.

   **Note:** _Some browsers don't work with this step. It is recommended to
   complete this step on a desktop or laptop computer using the Chrome browser._

1. Check the logs of the "Tailscale with features" app again to see if
   everything went well.

## Configuration

Consider disabling key expiry to avoid losing connection to your Home Assistant
device. See [Key expiry][tailscale_info_key_expiry] for more information.

Logging in to Tailscale, you can configure your Tailscale network right from
their interface.

<https://login.tailscale.com/>

## Add-on configuration

```yaml
accept_dns: true
accept_routes: false
advertise_connector: false
advertise_exit_node: false
advertise_routes:
  - local_subnets
  - 192.168.1.0/24
  - fd12:3456:abcd::/64
advertise_tags:
  - tag:example
  - tag:homeassistant
always_use_derp: false
dscp: 52
exit_node: 100.101.102.103
lets_encrypt_certfile: fullchain.pem
lets_encrypt_keyfile: privkey.pem
log_level: info
login_server: "https://controlplane.tailscale.com"
share_homeassistant: disabled
share_on_port: 443
share_service_name: "svc:homeassistant"
snat_subnet_routes: true
stateful_filtering: false
taildrive:
  addons: false
  addon_configs: false
  backup: false
  config: false
  media: false
  share: false
  ssl: false
taildrop: false
tailscale_ssh:
  enabled: false
  packages:
    - nodejs
    - npm
  init_commands:
    - npm config set prefix /data/npm
    - mkdir -p /data/npm/bin
userspace_networking: false
```

> [!NOTE]
> Some of the configuration options are also available on Tailscale's web
> interface through the Web UI, but they are made read only there. You can't
> change them through the Web UI, because all the changes made there would be
> lost when the app is restarted.

### Option: `accept_dns`

This option allows you to accept the DNS settings of your tailnet that are
configured on the [DNS page][tailscale_dns] of the admin console. When disabled,
Tailscale's DNS resolves only tailnet addresses, no global nameservers from the
admin console are applied.

For more information, see the "DNS" section of this documentation.

This option is enabled by default.

### Option: `accept_routes`

This option allows you to accept subnet routes advertised by other nodes in
your tailnet.

More information: [Subnet routers][tailscale_info_subnets]

This option is disabled by default.

### Option: `advertise_connector`

This option allows you to advertise this Tailscale instance as an app connector.

When you use an app connector, you specify which applications you wish to make
accessible over your tailnet, and the domains for those applications. Any traffic
for that application is then forced over the tailnet to a node running an app
connector before egressing to the target domains. This is useful for cases where
the application has an allowlist of IP addresses which can connect to it: the IP
address of the node running the app connector can be added to the allowlist, and
all nodes on the tailnet will use that IP address for their traffic egress.

More information: [App connectors][tailscale_info_app_connectors]

This option is disabled by default.

### Option: `advertise_exit_node`

This option allows you to advertise this Tailscale instance as an exit node.

By setting a device on your network as an exit node, you can use it to
route all your public internet traffic as needed, like a consumer VPN.

More information: [Exit nodes][tailscale_info_exit_nodes]

This option is disabled by default.

**Note:** You can't advertise this device as an exit node and at the same time
specify an exit node to use. See also the "Option: `exit_node`" section of this
documentation.

### Option: `advertise_routes`

This option allows you to advertise routes to subnets (accessible on the network
your device is connected to) to other clients on your tailnet.

By adding to the list the IP addresses and masks of the subnet routes, you can
use it to make your devices on these subnets accessible within your tailnet.

By adding `local_subnets` to the list, the app will advertise routes to your
subnets on all supported interfaces.

More information: [Subnet routers][tailscale_info_subnets]

**Note:** After you add subnets to this option, you also have to enable them on
Tailscale's admin console.

1. Navigate to the [Machines page][tailscale_machines] of the admin console, and
   find your Home Assistant instance.

1. Click on the **&hellip;** icon at the right side and select the "Edit route
   settings..." option. The "Exit node" and "Subnet routes" functions can be
   enabled here.

### Option: `advertise_tags`

This option allows you to specify specific tags for this Tailscale instance.
They need to start with `tag:`.

More information: [Tags][tailscale_info_tags]

### Option: `always_use_derp`

When enabled forces all peer communication over DERP by disabling the use of
UDP.

This option is disabled by default.

Basically you will never want to enable this option. Try to enable it only, when
you experience that connections to your Home Assistant device regularly freeze
(even when you can ping the device, the web page or the Home Assistant app is
unresponsive), and you have to reload the web page or force stop the Home
Assistant app to make them work again. The root cause can be that your ISP
erroneously drops UDP packets on certain conditions.

### Option: `dscp`

This option allows you to set DSCP value on all tailscaled originated network
traffic. This allows you to handle Tailscale's network traffic on your router
separately from other network traffic.

If you want to minimize the traffic on your mobile internet by restricting the
traffic to this DSCP value, you should also enable accessing the addresses below
without this DSCP value (ie. enable their usage for Home Assistant and other
apps):
- 162.159.200.1 (time.cloudflare.com)
- 162.159.200.123 (time.cloudflare.com)
- 1.1.1.1 (cloudflare dns)
- 1.0.0.1 (cloudflare dns)
- 8.8.8.8 (google dns)
- 8.8.4.4 (google dns)
- 172.65.32.248 (acme-v02.api.letsencrypt.org)
- 151.101.1.195 (mobile-apps.home-assistant.io)
- 151.101.65.195 (mobile-apps.home-assistant.io)
- 104.17.175.230 (api.pwnedpasswords.com)
- 104.17.96.141 (api.pwnedpasswords.com)
- x.x.x.x (your mobile internet stick's admin page)

When not set, this option is disabled by default, i.e. DSCP will be set to the
default 0. To make this option visible on the configuration editor, click "Show
unused optional configuration options" at the bottom of the page.

### Option: `exit_node`

This option allows you to specify another Tailscale instance as an exit node for
this device.

By setting a device on your network as an exit node, you can use it to
route all your public internet traffic as needed, like a consumer VPN.

More information: [Exit nodes][tailscale_info_exit_nodes]

This option is unused by default. To make it visible on the configuration
editor, click "Show unused optional configuration options" at the bottom of the
page.

**Note:** You can't advertise this device as an exit node and at the same time
specify an exit node to use. See also the "Option: `advertise_exit_node`"
section of this documentation.

**Note:** The `exit-node-allow-lan-access` option is always enabled when an exit
node is specified. This is required by the Home Assistant environment.

**Note:** After you enable this option, you also have to enable it on Tailscale's
admin console.

1. Navigate to the [Machines page][tailscale_machines] of the admin console, and
   find your Home Assistant instance.

1. Click on the **&hellip;** icon at the right side and select the "Edit route
   settings..." option. The "Exit node" and "Subnet routes" functions can be
   enabled here.

### _Note on the `lets_encrypt` options below_

_Until a bug in the Supervisor/UI is not fixed (see
[#4606](https://github.com/home-assistant/supervisor/issues/4606) and
[#2640](https://github.com/home-assistant/supervisor/issues/2640)), we can't use
the normal configuration schema (see below) as optional values. If the issues
get fixed in the future, configuration will be changed back to something better,
like:_

```
lets_encrypt:
  certfile: fullchain.pem
  keyfile: privkey.pem
```

### Option: `lets_encrypt_certfile`

This requires `share_homeassistant` option to be enabled and set up properly.

**Important:** See also the "Option: `share_homeassistant`" section of this
documentation for the necessary configuration changes in Home Assistant!

The name of the certificate file generated by Tailscale Serve using Let's
Encrypt. Use "." to save the file with the original name containing the domain
(like "homeassistant.tail1234.ts.net.crt"), or use the regular
"fullchain.pem" or any file or folder name you prefer.

Both `lets_encrypt` options (`lets_encrypt_certfile` and `lets_encrypt_keyfile`)
has to be specified or omitted together.

**Note:** The file is stored in the /ssl/ folder (which is the default for Home
Assistant), so **_do not_** start it with "/ssl", and **_do not_** start it with
"/" either.

When not set, this option is disabled by default. To make this option visible on
the configuration editor, click "Show unused optional configuration options" at
the bottom of the page.

### Option: `lets_encrypt_keyfile`

This requires `share_homeassistant` option to be enabled and set up properly.

**Important:** See also the "Option: `share_homeassistant`" section of this
documentation for the necessary configuration changes in Home Assistant!

The name of the private key file generated by Tailscale Serve using Let's
Encrypt. Use "." to save the file with the original name containing the domain
(like "homeassistant.tail1234.ts.net.key"), or use the regular
"privkey.pem" or any file or folder name you prefer.

Both `lets_encrypt` options (`lets_encrypt_certfile` and `lets_encrypt_keyfile`)
has to be specified or omitted together.

**Note:** The file is stored in the /ssl/ folder (which is the default for Home
Assistant), so **_do not_** start it with "/ssl", and **_do not_** start it with
"/" either.

When not set, this option is disabled by default. To make this option visible on
the configuration editor, click "Show unused optional configuration options" at
the bottom of the page.

### Option: `log_level`

Optionally enable tailscaled debug messages in the app's log. Turn it on only
in case you are troubleshooting, because Tailscale's daemon is quite chatty. If
`log_level` is set to `info` or less severe level, the app also opts out of
client log upload to log.tailscale.io.

The `log_level` option controls the level of log output by the app and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `notice`: Normal but significant events.
- `warning`: Exceptional occurrences that are not errors.
- `error`: Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. App becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

### Option: `login_server`

This option lets you to specify a custom control server instead of the default
(`https://controlplane.tailscale.com`). This is useful if you are running your
own Tailscale control server, for example, a self-hosted [Headscale] instance.

### Option: `share_homeassistant`

This option allows you to enable Tailscale Serve or Funnel features to present
your Home Assistant instance with a valid certificate on your tailnet or on the
internet.

This option is disabled by default.

Tailscale can provide a TLS certificate for your Home Assistant instance within
your tailnet domain.

This can prevent browsers from warning that HTTP URLs to your Home Assistant
instance look unencrypted (browsers are not aware that the connections between
Tailscale nodes are secured with end-to-end encryption).

With the Tailscale Serve feature, you can access your Home Assistant instance
with the provided certificate within your tailnet from devices already connected
to your tailnet.

With the Tailscale Funnel feature, you can access your Home Assistant instance
with the provided certificate not only within your tailnet but even from the
wider internet using your Tailscale domain (like
`https://homeassistant.tail1234.ts.net`) from devices **without installed
Tailscale VPN client** (for example, on general phones, tablets, and laptops).

**Client** &#8658; _Internet_ &#8658; **Tailscale Funnel** (TCP proxy) &#8658;
_VPN_ &#8658; **Tailscale Serve** (HTTPS proxy) &#8594; **HA** (HTTP web-server)

More information: [Enabling HTTPS][tailscale_info_https],
[Tailscale Serve][tailscale_info_serve], [Tailscale Funnel][tailscale_info_funnel].

1. Configure Home Assistant to be accessible through an HTTP connection (this is
   the default). See [HTTP integration documentation][http_integration] for more
   information. If you still want to use another HTTPS connection to access Home
   Assistant, please use a reverse proxy app.

1. Home Assistant, by default, blocks requests from reverse proxies, like the
   Tailscale Serve. To enable it, add the following lines to your
   `configuration.yaml`, without changing anything (don't forget to restart Home
   Assistant after the changes are saved):

   ```yaml
   http:
     use_x_forwarded_for: true
     trusted_proxies:
       - 127.0.0.1
   ```

1. Navigate to the [DNS page][tailscale_dns] of the admin console:
   - Choose a tailnet name.

   - Enable MagicDNS if not already enabled.

   - Under HTTPS Certificates section, click Enable HTTPS.

1. Optionally, if you want to use Tailscale Funnel, navigate to the [Access
   controls page][tailscale_acls] of the admin console:
   - Add the required `funnel` node attribute to the tailnet policy file. See
     [Tailnet policy file requirement][tailscale_info_funnel_policy_requirement]
     for more information.

1. Restart the app.

**Note**: After initial setup, it can take up to 10 minutes for the domain to
be publicly available.

**Note:** You should not use the port number in the URL that you used
previously to access Home Assistant. Tailscale Serve and Funnel works on the
default HTTPS port 443 (or the port configured in option `share_on_port`).

**Note:** If you encounter strange browser behaviour or strange error messages,
try to clear all site-related cookies, clear all browser cache, and restart the
browser.

**Note:** If you want to share other services than Home Assistant, see the
"Sharing other apps with serve or funnel" section of this documentation.

### Option: `share_on_port`

This option lets you specify which port the Tailscale Serve and Funnel features
will use to present your Home Assistant instance on the tailnet and on the
internet.

Only ports 443, 8443, and 10000 are allowed by Tailscale.

Port 443 is used by default.

### Option: `share_service_name`

This option lets you specify the service name the Tailscale Serve feature will
use to present your Home Assistant instance on the tailnet. It needs to start
with `svc:`.

**Note:** The Tailscale Funnel feature will ignore this option.

More information: [Services][tailscale_info_services]

This option is unused by default. To make it visible on the configuration
editor, click "Show unused optional configuration options" at the bottom of the
page.

### Option: `snat_subnet_routes`

This option allows subnet devices to see the traffic originating from the subnet
router, and this simplifies routing configuration.

This option is enabled by default.

To support advanced [Site-to-site networking][tailscale_info_site_to_site] (e.g.
to traverse multiple networks), you can disable this functionality, and follow
steps in the [Site-to-site networking][tailscale_info_site_to_site] guide (Note:
The app already handles "IP address forwarding" and "Clamp the MSS to the
MTU" for you).

**Note:** Only disable this option if you fully understand the implications.
Keep it enabled if preserving the real source IP address is not critical for
your use case.

### Option: `stateful_filtering`

This option enables stateful packet filtering on packet-forwarding nodes (exit
nodes, subnet routers, and app connectors), to only allow return packets for
existing outbound connections. Inbound packets that don't belong to an existing
connection are dropped.

This option is disabled by default.

### Option: `taildrive`

This option allows you to specify which Home Assistant directories you want to
share with other Tailscale nodes using Taildrive.

Only the listed directories are available.

These options are disabled by default.

More information: [Taildrive][tailscale_info_taildrive]

### Option: `taildrop`

This app supports [Tailscale's Taildrop][tailscale_info_taildrop] feature,
which allows you to send files to your Home Assistant instance from other
Tailscale devices.

This option is disabled by default.

Received files are stored in the `/share/taildrop` directory.

### Option group `tailscale_ssh`

This option configures Tailscale SSH and its shell environment.

#### Option: `tailscale_ssh.enabled`

Enables SSH capabilities that you can manage from your Tailscale account.

This option is disabled by default.

More information: [Tailscale SSH][tailscale_info_ssh]

**Note**: Using Tailscale SSH you will access only this app's command line,
**_not_** eg. the Advanced SSH app's command line!

#### Option: `tailscale_ssh.packages`

[Alpine packages][alpine-packages] to install on app startup to preconfigure
your Tailscale SSH shell.

Requires local network access. Failures (e.g. Alpine repositories are
unreachable) are non-blocking: the app logs a warning and continues so that
Tailscale can start.

**Note**: Only applies when `tailscale_ssh.enabled` is true.

**Note**: Package installation runs before Tailscale is started, ie. it bypasses
exit node if configured.

**Note**: Adding many packages will result in a longer startup time for the app.

#### Option: `tailscale_ssh.init_commands`

Custom commands to run on app startup to preconfigure your Tailscale SSH shell
(e.g. set npm prefix, create symlinks).

Each command is executed with `eval` in the shell. Failures are non-blocking:
the app logs a warning and continues so that Tailscale can start.

**Note**: Only applies when `tailscale_ssh.enabled` is true.

### Option: `userspace_networking`

When enabled, Tailscale will not create a `tailscale0` network interface on your
host, i.e. you get one-way access from tailnet clients to your Home Assistant
instance (and optionally the local subnets).

This option is disabled by default.

To be able to address other clients on your tailnet not only by their tailnet IP
but also by their tailnet name, see the "DNS" section of this documentation.

If you want to access other clients on your tailnet even from your local subnet,
follow steps in the [Site-to-site networking][tailscale_info_site_to_site] guide
(Note: The app already handles "IP address forwarding" and "Clamp the MSS to
the MTU" for you). See also the "Option: `snat_subnet_routes`" section of this
documentation.

More information: [Userspace networking
mode][tailscale_info_userspace_networking]

**Note:** In case your local subnets collide with subnet routes within your
tailnet, your local network access has priority, and these addresses won't be
routed toward your tailnet. This will prevent your Home Assistant instance from
losing network connection. This also means that using the same subnet on
multiple nodes for load balancing and failover is impossible with the current
app behavior.

## Network

### Port: `41641/udp`

UDP port to listen on for WireGuard and peer-to-peer traffic.

Use this option (and router port forwarding) if you experience that Tailscale
can't establish peer-to-peer connections to some of your devices (usually behind
CGNAT networks). You can test connections with `tailscale ping
<hostname-or-ip>`.

When not set, an automatically selected port is used by default.

## DNS

When the `userspace_networking` option is disabled, Tailscale provides a DNS (at
100.100.100.100 and fd7a:115c:a1e0::53) to be able to address other clients on
your tailnet not only by their tailnet IP but also by their tailnet name.

More information: [What is 100.100.100.100][tailscale_info_quad100],
[DNS in Tailscale][tailscale_info_dns], [MagicDNS][tailscale_info_magicdns],
[Access a Pi-hole from anywhere][tailscale_info_pi_hole].

1. Check that the `userspace_networking` option is disabled.

1. Check that under **Settings** -> **System** -> **Network** Tailscale's DNS is
   **_not_** configured as a DNS server.

1. In the command line, execute `ha dns options --servers dns://100.100.100.100`.

   **Note:** _This command replaces the existing DNS server list in Home
   Assistant and restarts the internal DNS server. To specify an empty DNS list
   (i.e. to remove `dns://100.100.100.100` from the list), you must use
   `ha dns reset` and `ha dns restart` commands both. This server list is
   additional and queried before the DNS servers specified in Network settings
   above. This configuration is persistent, you have to execute it only once._

**Note:** The only difference compared to the general Tailscale experience, is
that you always have to use the fully qualified domain name instead of only the
device name, i.e. `ping some-tailnet-device.tail1234.ts.net` works, but `ping
some-tailnet-device` does not work.

**Note:** If you are running your own DNS (like AdGuard) **_on this_** Home
Assistant device also, and this device is configured as global nameserver on the
[DNS page][tailscale_dns] of the admin console, then:

1. Disable the `accept_dns` option to prevent the Tailscale DNS from redirecting
   queries from your device back to itself, which would cause a loop.

1. Configure your own DNS for Home Assistant (instead of 100.100.100.100), and
   in your own DNS configure Tailscale DNS for your tailnet domain as upstream
   DNS server (e.g. in case of AdGuard `[/tail1234.ts.net/]100.100.100.100`).

## Healthcheck

Tailscale is quite resilient and can recover from nearly any network change. In
case it fails to recover, the app's health is set unhealthy. The app's
health is checked by Home Assistant in each 30s, and if it reports itself 3
times unhealthy in a row, the app will be restarted.

The app's health is set unhealthy:

- Once it was online and gets offline for longer than 5 minutes.

- After a (re)start can't get online for longer than 1 hour.

## Sharing other apps with serve or funnel

The `share_homeassistant` option allows you to enable Tailscale Serve or Funnel
features to present your Home Assistant instance.

If you want to share other apps than Home Assistant, it can be done, but
there is no app configuration option for this. Maybe Tailscale will add this
to the web UI in the future.

Requirements:

- You **_can't_** use the same port, that the app is using to share Home
  Assistant (the port that is configured under `share_on_port` option), the
  reason is that a foreground service is running on this port by the app, so
  you can't reuse this port, you have to use a different port (you can select
  from 443, 8443, and 10000 in case of funnel, or any port in case of serve).

- You must use the cli to set this up, but the config is permanent, you have to
  do this only once, it will work after a restart, or even backup/restore.

- Please check, that your other apps you want to share are using the host
  network or expose ports on the host, because you can't use anything else to
  share with Tailscale, only localhost is allowed.

- Please check, that your other apps are accessible through plain http,
  **_not_** https.

Steps:

1. In the cli (eg. Advanced SSH app
   https://github.com/hassio-addons/app-ssh) execute: ``docker exec -it
   `docker ps -q -f name=tailscale` /bin/bash`` Now you are in this app's
   cli.

1. Execute something like `/opt/tailscale serve --bg --service=svc:someservice
   --https=8443 --set-path=/someservice localhost:1234`

   - `serve` or `funnel`, your choice

   - `--bg` means Tailscale will start up the service in the backgroud, when the
     app is started, and Tailscale remembers this setting

   - `--service=svc:someservice` this is optional, and can be used only in case
     of serve, not funnel

     This is useful if you want to share your other app with a unique name and
     IP within your tailnet (not the device's tailnet name and IP), though have
     special requirements, like you must use a tag-based identity for this
     device and have to configure the service on Tailscale's admin page.

     More information: [Services][tailscale_info_services]

   - `--https:8443` must be different from the app's serve/funnel port, or
     you will get an "foreground already exists under this port" error from
     Tailscale

   - `--set-path=/someservice` if you plan to share multiple apps/ports without
     using Tailscale's service feature (see above), you can use different paths
     for each app, but most apps don't like being served from a different route,
     so usually you can use only `/`

   - `localhost:1234` port 1234 is where your other app is accessible on the
     localhost

   - You can disable/delete this config with `/opt/tailscale funnel --bg
     --service=svc:someservice --https=8443 --set-path=/someservice off`

1. You can add as many different apps as you want.

Result:

- You can access Home Assistant at https://devicename.tailxxxx.ts.net (with the
  help of the `share_homeassistant` option)

- You can access your other app at eg.
  https://devicename.tailxxxx.ts.net:8443/someservice or
  https://someservice.tailxxxx.ts.net:8443

**Note:** If your other app is not responding at
https://devicename.tailxxxx.ts.net:8443/someservice url:

- Turn on Inspect view in your browser and check what's going on (errors,
  network communication, etc.).

- Try `--set-path=/` in the serve/funnel config and try accessing the other app
  at https://devicename.tailxxxx.ts.net:8443/.

## Support

Got questions?

You have several options to get them answered:

- The [Home Assistant Discord chat server][discord].
- The Home Assistant [Community Forum][forum].
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]

You could also [open an issue here][issue] on GitHub.

[discord]: https://discord.gg/c5DvZ4e
[forum]: https://community.home-assistant.io/
[headscale]: https://github.com/juanfont/headscale
[http_integration]: https://www.home-assistant.io/integrations/http/
[issue]: https://github.com/lmagyar/homeassistant-addon-tailscale/issues
[reddit]: https://reddit.com/r/homeassistant
[warning_stripe]: https://github.com/lmagyar/homeassistant-addon-tailscale/raw/main/images/warning_stripe_wide.png
[community_app]: https://github.com/hassio-addons/app-tailscale
[alpine-packages]: https://pkgs.alpinelinux.org/packages
[tailscale_acls]: https://login.tailscale.com/admin/acls
[tailscale_dns]: https://login.tailscale.com/admin/dns
[tailscale_info_app_connectors]: https://tailscale.com/docs/features/app-connectors
[tailscale_info_dns]: https://tailscale.com/docs/reference/dns-in-tailscale
[tailscale_info_exit_nodes]: https://tailscale.com/docs/features/exit-nodes
[tailscale_info_funnel]: https://tailscale.com/docs/features/tailscale-funnel
[tailscale_info_funnel_policy_requirement]: https://tailscale.com/docs/features/tailscale-funnel#requirements-and-limitations
[tailscale_info_https]: https://tailscale.com/docs/how-to/set-up-https-certificates
[tailscale_info_key_expiry]: https://tailscale.com/docs/features/access-control/key-expiry
[tailscale_info_magicdns]: https://tailscale.com/docs/features/magicdns
[tailscale_info_pi_hole]: https://tailscale.com/docs/solutions/block-ads-all-devices-anywhere-using-raspberry-pi
[tailscale_info_quad100]: https://tailscale.com/docs/reference/quad100
[tailscale_info_serve]: https://tailscale.com/docs/features/tailscale-serve
[tailscale_info_services]: https://tailscale.com/docs/features/tailscale-services
[tailscale_info_site_to_site]: https://tailscale.com/docs/features/site-to-site
[tailscale_info_ssh]: https://tailscale.com/docs/features/tailscale-ssh
[tailscale_info_subnets]: https://tailscale.com/docs/features/subnet-routers
[tailscale_info_tags]: https://tailscale.com/docs/features/tags
[tailscale_info_taildrive]: https://tailscale.com/docs/features/taildrive
[tailscale_info_taildrop]: https://tailscale.com/docs/features/taildrop
[tailscale_info_userspace_networking]: https://tailscale.com/docs/concepts/userspace-networking
[tailscale_machines]: https://login.tailscale.com/admin/machines

# Home Assistant Custom Add-on: Tailscale with features

> [!CAUTION]
> Due to a Tailscale bug
> ([#15065](https://github.com/tailscale/tailscale/issues/15065)), when you try
> to log in to your tailnet, you will receive a "Failed to login" error message.
>
> Workaround: see the add-on's log, there is a line:
> ```
> To authenticate, visit:
> 	https://login.tailscale.com/a/xxxxxxxxxxxxxxxx
> ```

![Warning][warning_stripe]

> This is a **fork** of the [community add-on][community_addon]!
>
> Changes:
> - Release unreleased changes from community add-on:
>   - Update tailscale/tailscale to v1.84.0
>   - Add HEALTHCHECK support
>   - Fix MagicDNS incompatibility with Home Assistant
>   - Forward incoming tailnet connections to the host's primary interface
>   - Wait for local network on startup
>   - Update Add-on base image to v17.2.5
> - Release unmerged changes from community add-on:
>   - Make DSCP configurable on tailscaled's network traffic
>   - Configure log format for the add-on to be compatible with Tailscale's format
>   - Optionally copy Tailscale Proxy's certificate files to /ssl folder

![Warning][warning_stripe]

Tailscale is a zero config VPN, which installs on any device in minutes,
including your Home Assistant instance.

Create a secure network between your servers, computers, and cloud instances.
Even when separated by firewalls or subnets, Tailscale just works. Tailscale
manages firewall rules for you, and works from anywhere you are.

## Prerequisites

In order to use this add-on, you'll need a Tailscale account.

It is free to use for personal & hobby projects, up to 100 clients/devices on a
single user account. Sign up using your Google, Microsoft or GitHub account at
the following URL:

<https://login.tailscale.com/start>

You can also create an account during the add-on installation processes,
however, it is nice to know where you need to go later on.

## Installation

1. Navigate in your Home Assistant frontend to **Settings** -> **Add-ons** ->
   **Add-on Store**.
1. In the **...** menu at the top right corner click **Repositories**, add
   `https://github.com/lmagyar/homeassistant-addon-tailscale` as repository.
1. Find the "Tailscale with features" add-on and click it. If it doesn't show
   up, wait until HA refreshes the information about the add-on, or click
   **Check for updates** in the **...** menu at the top right corner.
1. Click the "INSTALL" button.

## How to use

1. Start the "Tailscale with features" add-on.
1. Check the logs of the "Tailscale with features" add-on to see if everything
   went well.
1. Open the **Web UI** of the "Tailscale with features" add-on to complete
   authentication and couple your Home Assistant instance with your Tailscale
   account.

   **Note:** _Some browsers don't work with this step. It is recommended to
   complete this step on a desktop or laptop computer using the Chrome browser._

> [!CAUTION]
> Due to a Tailscale bug
> ([#15065](https://github.com/tailscale/tailscale/issues/15065)), when you try
> to log in to your tailnet, you will receive a "Failed to login" error message.
>
> Workaround: see the add-on's log, there is a line:
> ```
> To authenticate, visit:
> 	https://login.tailscale.com/a/xxxxxxxxxxxxxxxx
> ```

1. Check the logs of the "Tailscale with features" add-on again to see if
   everything went well.

## Configuration

This add-on has almost no additional configuration options for the
add-on itself.

However, when logging in to Tailscale, you can configure your Tailscale
network right from their interface.

<https://login.tailscale.com/>

The add-on exposes "Exit Node" capabilities that you can enable from your
Tailscale account. Additionally, if the Supervisor managed your network (which
is the default), the add-on will also advertise routes to your subnets on all
supported interfaces to Tailscale.

Consider disabling key expiry to avoid losing connection to your Home Assistant
device. See [Key expiry][tailscale_info_key_expiry] for more information.

1. Navigate to the [Machines page][tailscale_machines] of the admin console, and
   find your Home Assistant instance.

1. Click on the **&hellip;** icon at the right side and select the "Edit route
   settings..." option. The "Exit node" and "Subnet routes" functions can be
   enabled here.

1. Click on the **&hellip;** icon at the right side and select the "Disable key
   expiry" option.

## Add-on configuration

```yaml
accept_dns: true
accept_routes: true
advertise_exit_node: true
advertise_connector: true
advertise_routes:
  - 192.168.1.0/24
  - fd12:3456:abcd::/64
dscp: 52
funnel: false
lets_encrypt_certfile: fullchain.pem
lets_encrypt_keyfile: privkey.pem
log_level: info
login_server: "https://controlplane.tailscale.com"
proxy: false
proxy_and_funnel_port: 443
snat_subnet_routes: true
stateful_filtering: false
tags:
  - tag:example
  - tag:homeassistant
taildrop: true
userspace_networking: true
```

> [!NOTE]
> Some of the configuration options are also available on Tailscale's web
> interface through the Web UI, but they are made read only there. You can't
> change them through the Web UI, because all the changes made there would be
> lost when the add-on is restarted.

> [!CAUTION]
> Due to limitations in Home Assistant's UI, **do not use** the "Show unused
> optional configuration options" switch on the Configuration tab!

> [!CAUTION]
> When you want to change the default behaviour of these optional configuration
> options, **add them to the YAML add-on configuration manually**, by using the
> "Edit in YAML" in the ... menu on the right and save them! Use the UI to edit
> them only after you added them manually!

> [!WARNING]
> Home Assistant's UI will show you all the optional configuration options
> turned off instead of grayed out. You will falsely believe that those are the
> values that will be stored, so you will enable options, that by default are
> already enabled when unused, and you will let options be disabled, that you
> originally wanted to disable. But the **UI will not add these disabled
> optional configuration options** to the YAML add-on configuration, and at the
> end nothing will change in the add-on's functionality after a restart!

### Option: `accept_dns`

This option allows you to accept the DNS settings of your tailnet that are
configured on the [DNS page][tailscale_dns] of the admin console. When disabled,
Tailscale's DNS resolves only tailnet addresses

For more information, see the "DNS" section of this documentation.

When not set, this option is enabled by default.

### Option: `accept_routes`

This option allows you to accept subnet routes advertised by other nodes in
your tailnet.

More information: [Subnet routers][tailscale_info_subnets]

When not set, this option is enabled by default.

### Option: `advertise_exit_node`

This option allows you to advertise this Tailscale instance as an exit node.

By setting a device on your network as an exit node, you can use it to
route all your public internet traffic as needed, like a consumer VPN.

More information: [Exit nodes][tailscale_info_exit_nodes]

When not set, this option is enabled by default.

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

When not set, this option is enabled by default.

### Option: `advertise_routes`

This option allows you to advertise routes to subnets (accessible on the network
your device is connected to) to other clients on your tailnet.

By adding to the list the IP addresses and masks of the subnet routes, you can
use it to make your devices on these subnets accessible within your tailnet.

If you want to disable this option, specify an empty list in the configuration
(`[]` in YAML).

More information: [Subnet routers][tailscale_info_subnets]

When not set, the add-on by default will advertise routes to your subnets on all
supported interfaces.

### Option: `dscp`

This option allows you to set DSCP value on all tailscaled originated network
traffic. This allows you to handle Tailscale's network traffic on your router
separately from other network traffic.

When not set, this option is disabled by default, i.e. DSCP will be set to the
default 0.

### Option: `funnel`

This requires Tailscale Proxy to be enabled.

**Important:** See also the "Option: `proxy`" section of this documentation for the
necessary configuration changes in Home Assistant!

When not set, this option is disabled by default.

With the Tailscale Funnel feature, you can access your Home Assistant instance
from the wider internet using your Tailscale domain (like
`https://homeassistant.tail1234.ts.net`) even from devices **without installed
Tailscale VPN client** (for example, on general phones, tablets, and laptops).

**Client** &#8658; _Internet_ &#8658; **Tailscale Funnel** (TCP proxy) &#8658;
_VPN_ &#8658; **Tailscale Proxy** (HTTPS proxy) &#8594; **HA** (HTTP web-server)

Without the Tailscale Funnel feature, you will be able to access your Home
Assistant instance only when your devices (for example, phones, tablets, and laptops)
are connected to your Tailscale VPN, there will be no Internet &#8658; VPN TCP
proxying for HTTPS communication.

More information: [Tailscale Funnel][tailscale_info_funnel]

1. Navigate to the [Access controls page][tailscale_acls] of the admin console:

   - Add the required `funnel` node attribute to the tailnet policy file. See
     [Tailnet policy file requirement][tailscale_info_funnel_policy_requirement]
     for more information.

1. Restart the add-on.

**Note**: _After initial setup, it can take up to 10 minutes for the domain to
be publicly available._

**Note:** _You should not use the port number in the URL that you used
previously to access Home Assistant. Tailscale Funnel works on the default HTTPS
port 443 (or the port configured in option `proxy_and_funnel_port`)._

**Note:** _If you encounter strange browser behaviour or strange error messages,
try to clear all site related cookies, clear all browser cache, restart browser._

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

This requires Tailscale Proxy to be enabled and set up properly.

**Important:** See also the "Option: `proxy`" section of this documentation for
the necessary configuration changes in Home Assistant!

The name of the certificate file generated by Tailscale Proxy using Let's
Encrypt. Use "." to save the file with the original name containing the domain
(like "homeassistant.tail1234.ts.net.crt"), or use the regular
"fullchain.pem" or any file or folder name you prefer.

Both `lets_encrypt` options (`lets_encrypt_certfile` and `lets_encrypt_keyfile`)
has to be specified or omitted together.

**Note:** The file is stored in the /ssl/ folder, which is the default for Home
Assistant.

When not set, this option is disabled by default.

### Option: `lets_encrypt_keyfile`

This requires Tailscale Proxy to be enabled and set up properly.

**Important:** See also the "Option: `proxy`" section of this documentation for
the necessary configuration changes in Home Assistant!

The name of the private key file generated by Tailscale Proxy using Let's
Encrypt. Use "." to save the file with the original name containing the domain
(like "homeassistant.tail1234.ts.net.key"), or use the regular
"privkey.pem" or any file or folder name you prefer.

Both `lets_encrypt` options (`lets_encrypt_certfile` and `lets_encrypt_keyfile`)
has to be specified or omitted together.

**Note:** The file is stored in the /ssl/ folder, which is the default for Home
Assistant.

When not set, this option is disabled by default.

### Option: `log_level`

Optionally enable tailscaled debug messages in the add-on's log. Turn it on only
in case you are troubleshooting, because Tailscale's daemon is quite chatty. If
`log_level` is set to `info` or less severe level, the add-on also opts out of
client log upload to log.tailscale.io.

The `log_level` option controls the level of log output by the addon and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `notice`: Normal but significant events.
- `warning`: Exceptional occurrences that are not errors.
- `error`: Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

### Option: `login_server`

This option lets you to specify a custom control server instead of the default
(`https://controlplane.tailscale.com`). This is useful if you are running your
own Tailscale control server, for example, a self-hosted [Headscale] instance.

### Option: `proxy`

When not set, this option is disabled by default.

Tailscale can provide a TLS certificate for your Home Assistant instance within
your tailnet domain.

This can prevent browsers from warning that HTTP URLs to your Home Assistant instance
look unencrypted (browsers are not aware of the connections between Tailscale
nodes are secured with end-to-end encryption).

More information: [Enabling HTTPS][tailscale_info_https]

1. Configure Home Assistant to be accessible through an HTTP connection (this is
   the default). See [HTTP integration documentation][http_integration] for more
   information. If you still want to use another HTTPS connection to access Home
   Assistant, please use a reverse proxy add-on.

1. Home Assistant, by default, blocks requests from reverse proxies, like the
   Tailscale Proxy. To enable it, add the following lines to your
   `configuration.yaml`, without changing anything:

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

1. Restart the add-on.

**Note:** _You should not use the port number in the URL that you used
previously to access Home Assistant. Tailscale Proxy works on the default HTTPS
port 443 (or the port configured in option `proxy_and_funnel_port`)._

### Option: `proxy_and_funnel_port`

This option allows you to configure the port the Tailscale Proxy and Funnel
features are accessible on the tailnet (in case of Tailscale Proxy is enabled)
and optionally on the internet (in case of Tailscale Funnel is also enabled).

Only port number 443, 8443 and 10000 is allowed by Tailscale.

When not set, port number 443 is used by default.

### Option: `snat_subnet_routes`

This option allows subnet devices to see the traffic originating from the subnet
router, and this simplifies routing configuration.

When not set, this option is enabled by default.

To support advanced [Site-to-site networking][tailscale_info_site_to_site] (e.g.
to traverse multiple networks), you can disable this functionality, and follow
steps in the [Site-to-site networking][tailscale_info_site_to_site] guide (Note:
The add-on already handles "IP address forwarding" and "Clamp the MSS to the
MTU" for you).

**Note:** Only disable this option if you fully understand the implications.
Keep it enabled if preserving the real source IP address is not critical for
your use case.

### Option: `stateful_filtering`

This option enables stateful packet filtering on packet-forwarding nodes (exit
nodes, subnet routers, and app connectors), to only allow return packets for
existing outbound connections. Inbound packets that don't belong to an existing
connection are dropped.

When not set, this option is disabled by default.

### Option: `tags`

This option allows you to specify specific tags for this Tailscale instance.
They need to start with `tag:`.

More information: [Tags][tailscale_info_tags]

### Option: `taildrop`

This add-on support [Tailscale's Taildrop][taildrop] feature, which allows
you to send files to your Home Assistant instance from other Tailscale
devices.

When not set, this option is enabled by default.

Received files are stored in the `/share/taildrop` directory.

### Option: `userspace_networking`

The add-on uses [userspace networking mode][tailscale_info_userspace_networking]
to make your Home Assistant instance (and optionally the local subnets)
accessible within your tailnet.

When not set, this option is enabled by default.

If you need to access other clients on your tailnet from your Home Assistant
instance, disable userspace networking mode, which will create a `tailscale0`
network interface on your host.

To be able to address other clients on your tailnet not only with their tailnet
IP, but with their tailnet name, see the "DNS" section of this documentation.

If you want to access other clients on your tailnet even from your local subnet,
follow steps in the [Site-to-site networking][tailscale_info_site_to_site] guide
(Note: The add-on already handles "IP address forwarding" and "Clamp the MSS to
the MTU" for you).

**Note:** In case your local subnets collide with subnet routes within your
tailnet, your local network access has priority, and these addresses won't be
routed toward your tailnet. This will prevent your Home Assistant instance from
losing network connection. This also means that using the same subnet on
multiple nodes for load balancing and failover is impossible with the current
add-on behavior.

**Note:** The `userspace_networking` option can remain enabled if you only need
one-way access from tailnet clients to your local subnet, without requiring
access from your local subnet to other tailnet clients.

**Note:** If you implement Site-to-site networking, but you are not interested
in the real source IP address, i.e. subnet devices can see the traffic
originating from the subnet router, you don't need to disable the
`snat_subnet_routes` option, this can simplify routing configuration.

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
100.100.100.100) to be able to address other clients on your tailnet not only
with their tailnet IP, but with their tailnet name.

More information: [What is 100.100.100.100][tailscale_info_quad100], [DNS in
Tailscale][tailscale_info_dns], [MagicDNS][tailscale_info_magicdns], [Access a
Pi-hole from anywhere][tailscale_info_pi_hole]

1. Check that the `userspace_networking` option is disabled.

1. Under **Settings** -> **System** -> **Network** configure Tailscale's DNS as
   the first DNS server (IPv4: 100.100.100.100, IPv6: fd7a:115c:a1e0::53).

1. Move your normal DNS servers (e.g. 192.168.1.1 or 1.1.1.1) to lower
   positions.

**Note:** The only difference compared to the general Tailscale experience, is
that you always have to use the fully qualified domain name instead of only the
device name, i.e. `ping some-tailnet-device.tail1234.ts.net` works, but `ping
some-tailnet-device` does not work.

**Note:** If you are running your own DNS (like AdGuard) on this Home Assistant
device also, and this device is configured as global nameserver on the [DNS
page][tailscale_dns] of the admin console, then:

1. Disable the `accept_dns` option to prevent the Tailscale DNS to redirect
   queries from your device back to your device, causing a loop.

1. Configure your DNS for Home Assistant, and in your DNS configure Tailscale
   DNS for your tailnet domain as upstream DNS server (e.g. in case of AdGuard
   `[/tail1234.ts.net/]100.100.100.100`).

## Healthcheck

Tailscale is quite resilient and can recover from nearly any network change. In
case it fails to recover, the add-on's health is set unhealthy. The add-on's
health is checked by Home Assistant in each 30s, and if it reports itself 3
times unhealthy in a row, the add-on will be restarted.

The add-on's health is set unhealthy:

- Once it was online and gets offline for longer than 5 minutes.

- After a (re)start can't get online for longer than 1 hour.

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
[taildrop]: https://tailscale.com/taildrop
[warning_stripe]: https://github.com/lmagyar/homeassistant-addon-tailscale/raw/main/images/warning_stripe_wide.png
[community_addon]: https://github.com/hassio-addons/addon-tailscale
[tailscale_acls]: https://login.tailscale.com/admin/acls
[tailscale_dns]: https://login.tailscale.com/admin/dns
[tailscale_info_dns]: https://tailscale.com/kb/1054/dns
[tailscale_info_exit_nodes]: https://tailscale.com/kb/1103/exit-nodes
[tailscale_info_app_connectors]: https://tailscale.com/kb/1281/app-connectors
[tailscale_info_funnel]: https://tailscale.com/kb/1223/funnel
[tailscale_info_funnel_policy_requirement]: https://tailscale.com/kb/1223/funnel#requirements-and-limitations
[tailscale_info_https]: https://tailscale.com/kb/1153/enabling-https
[tailscale_info_key_expiry]: https://tailscale.com/kb/1028/key-expiry
[tailscale_info_magicdns]: https://tailscale.com/kb/1081/magicdns
[tailscale_info_pi_hole]: https://tailscale.com/kb/1114/pi-hole
[tailscale_info_quad100]: https://tailscale.com/kb/1381/what-is-quad100
[tailscale_info_site_to_site]: https://tailscale.com/kb/1214/site-to-site
[tailscale_info_subnets]: https://tailscale.com/kb/1019/subnets
[tailscale_info_tags]: https://tailscale.com/kb/1068/tags
[tailscale_info_userspace_networking]: https://tailscale.com/kb/1112/userspace-networking
[tailscale_machines]: https://login.tailscale.com/admin/machines

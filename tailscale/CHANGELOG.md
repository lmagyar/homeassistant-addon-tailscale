# Changelog

- Add HEALTHCHECK support

## 0.17.0.2 (forked)

- Merge unreleased changes from community add-on
  - Update tailscale/tailscale to v1.64.0

## 0.17.0.1 (forked)

- Merge unmerged changes from community add-on
  - Fix tag name validation regex
- Merge unreleased changes from community add-on
  - Update Add-on base image to v15.0.8

## 0.17.0.0 (forked)

- Merge released changes from community add-on
  - Update tailscale/tailscale to v1.62.1

## 0.16.1.1 (forked)

- Merge unreleased changes from community add-on
  - Update tailscale/tailscale to v1.62.0

## 0.16.0.1 (forked)

- Merge unreleased changes from community add-on
  - Update tailscale/tailscale to v1.60.1

## 0.16.0.0 (forked)

- Merge released changes from community add-on
  - Update tailscale/tailscale to v1.60.0
  - Use readonly webui mode in v1.60.0
  - Update Add-on base image to v15.0.7

## 0.15.0.1 (forked)

- Drop kernel configuration access (really fixes [#325](https://github.com/hassio-addons/addon-tailscale/issues/325))

## 0.14.0.1 (forked)

***Note: Do not use the Tailscale web UI to modify `advertise_exit_node` and `advertise_routes` settings, the next restart of the add-on will overwrite those changes. Soon a locked read-only web UI option will be released by Tailscale to address this issue (see [#10999](https://github.com/tailscale/tailscale/pull/10999)).***

- Merge unreleased changes from community add-on
  - Fix kernel configuration access for Debian Supervised installations (fixes [#325](https://github.com/hassio-addons/addon-tailscale/issues/325))
  - Update tailscale/tailscale to v1.58.2
  - Update Add-on base image to v15.0.6

## 0.14.0.0 (forked)

This version is basically equivalent with the 0.14.0 community add-on version. Only remaining additional functionality:
- Optionally copy Tailscale Proxy's certificate files to /ssl folder

***BREAKING CHANGES:***
- Configuring Tailscale Proxy and Funnel port from now on is done by the `proxy_and_funnel_port` add-on config option and not by the networking host port configuration section. This is the accepted and merged solution for this issue.

Nonbreaking changes:
- Merge released changes from original add-on
  - Increase wait time for Supervisor
  - Wait for HA to be available during startup
  - Update Add-on base image to v15.0.3

## 0.13.1.7 (forked)

***BREAKING CHANGES:***
- Remove: Advanced Tailscale Proxy and Funnel configuration - ie. advanced_config option (after the add-on doesn't reset serve config, manual configuration will not interfere with it)

Nonbreaking changes:
- Merge funnel and proxy services into longrun serve service, drop internal serve config reset
- Merge unreleased changes from original add-on
  - Update tailscale/tailscale to v1.56.1

## 0.13.1.6 (forked)

- Fix: Clamping the MSS for IPv6 also
- Fix: Certificate export log message
- Merge unreleased changes from original add-on
  - Update tailscale/tailscale to v1.56.0
  - Update Add-on base image to v15.0.1 (Update Alpine base image to v3.19.0)

## 0.13.1.5 (forked)

***BREAKING CHANGES:***
- Remove: Make auth-key configurable

Nonbreaking changes:
- Fix certificate copy on first startup
- Merge unreleased changes from original add-on
  - Update tailscale/tailscale to v1.54.1

## 0.13.1.4 (forked)

- Merge unreleased changes from original add-on
  - Update tailscale/tailscale to v1.54.0
  - Update Add-on base image to v14.3.2

## 0.13.1.3 (forked)

- Advanced Tailscale Proxy and Funnel configuration
- Fix certificate export: Do not swallow real error messages from inotifywait
- Fix certificate export: Do not fail on first startup if certs dir doesn't exist

## 0.13.1.2 (forked)

- Merge unreleased changes from original add-on
  - Update tailscale/tailscale to v1.52.1

## 0.13.1.1 (forked)

- Use modified tailscale cli arguments for serve and funnel
- Merge unreleased changes from original add-on
  - Update tailscale/tailscale to v1.52.0

## 0.13.1.0 (forked)

- Merge changes from original add-on
  - Update Add-on base image to v14.3.1

## 0.13.0.1 (forked)

***BREAKING CHANGES:***
- Drop support for armhf & i386, because this is dropped from the original add-on repo also

Nonbreaking changes:
- Bugfix: Test Home Assistant's HTTP reverse proxy configuration on add-on start _only when Home Assistant is running_
- Merge changes from original add-on
  - Sync all details of the merged and unmerged PRs
  - Update Add-on base image to v14.3.0

## 0.12.0.1 (forked)

***BREAKING CHANGES:***
- Proxy and Funnel is disabled by default, because this got to be the default in the original add-on.
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
- Merge changes from original add-on
  - Sync all details of the merged and unmerged PRs
  - Update Add-on base image to v14.2.2

## 0.11.1.26 (forked)

- Warn when userspace networking is used to turn it off to access other clients on the tailnet
- Merge (unreleased) changes from original add-on
  - Update tailscale/tailscale to v1.50.1
  - Update Add-on base image to v14.2.0

## 0.11.1.25 (forked)

- Use new v1.50.0 .Self.CapMap in status json for https proxy and funnel support check
- Merge (unreleased) changes from original add-on
  - Update tailscale/tailscale to v1.50.0

## 0.11.1.24 (forked)

- Detect kernel support for MSS clamping and skip it if not supported (workaround for HA OS Odroid N2)
- Merge (unreleased) changes from original add-on
  - Update Add-on base image to v14.1.1

## 0.11.1.23 (forked)

- Merge (unreleased) changes from original add-on
  - Update tailscale/tailscale to v1.48.2

## 0.11.1.22 (forked)

- Warn about key expiration on add-on startup

## 0.11.1.21 (forked)

- Properly test Home Assistant's HTTP reverse proxy configuration (especially test `use_x_forwarded_for` settings)

  ***IMPORTANT: Read proxy documentation before updating, this update can cause the add-on to not start, it can be a breaking change! If you don't use proxy functinality, disable it before installing this update!***

## 0.11.1.20 (forked)

- Make accepting subnet routes configurable (from PR [#252](https://github.com/hassio-addons/addon-tailscale/pull/252) by [@willnorris](https://github.com/willnorris))

## 0.11.1.19 (forked)

- Merge (unreleased) changes from original add-on
  - Update tailscale/tailscale to v1.48.1

## 0.11.1.18 (forked)

- Handle previous non-graceful stop of add-on
- Merge (unreleased) changes from original add-on
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
- Merge (unreleased) changes from original add-on
  - Update Add-on base image to v14.1.0 (Update Alpine base image to v3.18.3)

## 0.11.1.12 (forked)

- Merge (unreleased) changes from original add-on
  - Update Add-on base image to v14.0.7

## 0.11.1.11 (forked)

- Make advertised subnet routes configurable
- Fix issue [#43](https://github.com/lmagyar/homeassistant-addon-tailscale/issues/43) (HA OS VM IPv6 multiple routing tables are not enabled)
- Allow proxy connection to HTTPS Home Assistant instance with insecure HTTPS proxying
- Reset proxy configuration on startup
- Merge (unreleased) changes from original add-on
  - Update tailscale/tailscale to v1.46.1
  - Update Add-on base image to v14.0.6

## 0.11.1.10 (forked)

- Make subnet source NAT configurable (to support advanced site-to-site networking)
- Clamp the MSS to the MTU for all advertised subnet's interface (to support site-to-site networking better)
- Fix local subnet collision protection (to protect even when the network is reconfigured)

## 0.11.1.9 (forked)

- Sign add-on with Sigstore Cosign
- Merge (unreleased) changes from original add-on
  - Update tailscale/tailscale to v1.44.0
  - Update Add-on base image to v14.0.2

## 0.11.1.8 (forked)

- Do not opt out of client log upload in debug log level (fixes [#211](https://github.com/hassio-addons/addon-tailscale/issues/211))
- Create fallback page for iOS browsers failing to open Tailscale login page (from PR [#198](https://github.com/hassio-addons/addon-tailscale/pull/198) by [@bitfliq](https://github.com/bitfliq))

## 0.11.1.7 (forked)

- Fix ip rule manipulation for IPv6 (in case of non-userspace networking and colliding subnets)
- Merge (unreleased) changes from original add-on
  - Update tailscale/tailscale to v1.42.0

## 0.11.1.6 (forked)

- Notify about colliding subnet routes
- Merge (unreleased) changes from original add-on
  - Update Add-on base image to v14 (Update Alpine base image to v3.18.0)

## 0.11.1.5 (forked)

- Merge (unreleased) changes from original add-on
  - Update tailscale/tailscale to v1.40.1

## 0.11.1.4 (forked)

- Protect local subnets from being routed toward Tailscale subnets if they collide

## 0.11.1.3 (forked)

- Make userspace networking configurable

## 0.11.1.2 (forked)

- Merge (unreleased) changes from original add-on
  - Enable Tailscale's builtin inbound HTTPS proxy
  - Drop userspace networking
  - Make accepting magicDNS optional

## 0.11.1.1 (forked)

- Make Proxy and Funnel configurable
- Remove Tailscale's SOCKS5 and HTTP outbound proxy (not needed after userspace networking is dropped)
- Merge (unreleased) changes from original add-on
  - Update tailscale/tailscale to v1.40.0
  - Make Taildrop configurable
  - Make exit node advertisement configurable
  - Add custom control server support
  - Update Add-on base image to v13.2.2

## 0.10.1.3 (forked)

- Put local UI webserver on to different port than original add-on's

## 0.10.1.2 (forked)

- Bugfix for login server config

## 0.10.1.1 (forked)

- Allow customizing the login server (from PR [#175](https://github.com/hassio-addons/addon-tailscale/pull/175) by [@reey](https://github.com/reey))
- Merge changes from original add-on
  - Update tailscale/tailscale to v1.38.4

## 0.10.0.1 (forked)

- Remove ACL tagging recommendation from Funnel documentation, finally `autogroup:members` works
- Merge changes from original add-on
  - Add support for Taildrop

## 0.9.0.6 (forked)

- Use the default add-on network config UI for SOCKS5 and HTTP outbound proxy port configuration

## 0.9.0.5 (forked)

- Remove duplicate status checks from dependent S6 services

## 0.9.0.4 (forked)

- Remove unneeded add-on privileges

## 0.9.0.3 (forked)

- Enable Tailscale's Funnel feature

## 0.9.0.2 (forked)

- Enable Tailscale's SOCKS5 and HTTP outbound proxy

## 0.9.0.1 (forked)

- Move Tailscale Proxy functionality into standalone oneshot S6 service
- Merge changes from original add-on
  - Advertise all supported interfaces as Tailscale Subnets
  - Suppress tailscaled logs after 200 lines
  - Bump Tailscale to 1.38.3
  - Bump base image to 13.2.0

## 0.8.0.1 (forked)

- Merge PR modifications
- Merge changes from original add-on
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

- Only optionally enable tailscaled debug messages in the add-on's log

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

For previous changelog see the original add-on's [release history](https://github.com/hassio-addons/addon-tailscale/releases).

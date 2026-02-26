# Home Assistant Custom App: Tailscale with features

Zero config VPN for building secure networks.

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
> - Withhold changes from community app (will be released here later)
>   - Drop support for armv7 architecture
>   - Update App base image to v20 (drop armv7 support)
> - Release unmerged changes from community app
>   - Make Tailscale SSH configurable
>   - Create persistent notification also (not just log warning) when key expiration is detected
>   - Optionally copy Tailscale Serve's certificate files to /ssl folder
>   - Make DSCP configurable on tailscaled's network traffic
>   - Configure log format for the app to be compatible with Tailscale's format

> One-click migration from the community app to this fork:
> - Install the **Advanced SSH & Web Terminal** app and disable it's protection mode
> - From the cli execute: `curl -s -o /tmp/migrate_from_community_add_on https://raw.githubusercontent.com/lmagyar/homeassistant-addon-tailscale/refs/heads/main/scripts/migrate_from_community_add_on && bashio /tmp/migrate_from_community_add_on`
>
> **Note:**
> - This will install the forked version (if not alredy installed), backup and
>   stop the community version, copy and update the configuration, and (this is
>   the big thing) will also copy the internal state of the app, then start
>   the forked version.
> - With copying the app internal state, the new forked app will start up
>   with the exact same state, ie. with the same tailnet authentication also. So
>   **do not** remove the current device from Tailscale's admin page, the forked
>   app will jump into it's place.
> - And even if you executed previously some tailscale configuration inside the
>   apps container, those settings will be also migrated with the internal
>   state.
> - **But copying the app's internal state requires executing bash and python
>   scripts inside the Supervisors container! Executng python scripts requires
>   installing gdb and pyrasite inside the Supervisor's container (they will be
>   uninstalled by the script also). So please create a complete system backup
>   before executing this script!**

| <img width="75%" title="Migration log" src="https://github.com/lmagyar/homeassistant-addon-tailscale/raw/main/images/migration_log.png"> |
| :---: |
| _Migration log (from the community app to this fork)_ |

![Warning][warning_stripe]

[![GitHub Release][releases-shield]][releases]
[![Last Updated][updated-shield]][updated]
![Reported Installations][installations-shield]
![Project Stage][project-stage-shield]
[![License][license-shield]][licence]

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

[![Github Actions][github-actions-shield]][github-actions]
![Project Maintenance][maintenance-shield]
[![GitHub Activity][commits-shield]][commits]

## About

Tailscale is a zero config VPN, which installs on any device in minutes,
including your Home Assistant instance.

Create a secure network between your servers, computers, and cloud instances.
Even when separated by firewalls or subnets, Tailscale just works. Tailscale
manages firewall rules for you, and works from anywhere you are.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-no-red.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[commits-shield]: https://img.shields.io/github/commit-activity/y/lmagyar/homeassistant-addon-tailscale.svg
[commits]: https://github.com/lmagyar/homeassistant-addon-tailscale/commits/main
[github-actions-shield]: https://github.com/lmagyar/homeassistant-addon-tailscale/workflows/Publish/badge.svg
[github-actions]: https://github.com/lmagyar/homeassistant-addon-tailscale/actions
[i386-shield]: https://img.shields.io/badge/i386-no-red.svg
[installations-shield]: https://img.shields.io/badge/dynamic/json?label=reported%20installations&query=$[%2709716aab_tailscale%27].total&url=https%3A%2F%2Fanalytics.home-assistant.io%2Faddons.json
[license-shield]: https://img.shields.io/github/license/lmagyar/homeassistant-addon-tailscale.svg
[licence]: https://github.com/lmagyar/homeassistant-addon-tailscale/blob/main/LICENSE
[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-beta-orange.svg
[releases-shield]: https://img.shields.io/github/tag/lmagyar/homeassistant-addon-tailscale.svg?label=release
[releases]: https://github.com/lmagyar/homeassistant-addon-tailscale/tags
[updated-shield]: https://img.shields.io/github/last-commit/lmagyar/homeassistant-addon-tailscale/main?label=updated
[updated]: https://github.com/lmagyar/homeassistant-addon-tailscale/commits/main
[warning_stripe]: https://github.com/lmagyar/homeassistant-addon-tailscale/raw/main/images/warning_stripe_wide.png
[community_app]: https://github.com/hassio-addons/app-tailscale

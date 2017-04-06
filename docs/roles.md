# Understanding Ubiquitous roles

In Ubiquitous, a role is an individual Salt state with a corresponding Salt grain. The following roles are provided:

| Role | Description |
| --- | --- |
| [`app`](#application-server-app) | Application server (PHP, nginx) |
| [`app-debug`](#with-debugging-support-app-debug) | Add-on for application server providing Xdebug |
| [`app-gocd-agent`](#with-bluegreen-deployments-app-gocd-agent) | Add-on for application server providing downtime-free deployment scripts for use with GoCD |
| [`db-pgsql`](#postgresql-database-db-pgsql) | PostgreSQL database server |
| [`gocd-agent`](#gocd-agent-gocd-agent) | Vanilla GoCD agent |
| [`gocd-server`](#gocd-server-gocd-server) | Vanilla GoCD server |
| [`mail-debug`](#mail-debugging-mail-debug) | MailCatcher |
| [`named`](#name-server-named) | Bind DNS server |
| [`salt`](#salt-master-salt) | Salt master for configuration management |
| [`selenium-hub`](#selenium-hub-selenium-hub) |  Selenium grid hub server |
| [`selenium-node-chrome`](#selenium-chrome-node-selenium-node-chrome) | Selenium grid node (Chrome) |
| [`selenium-node-firefox`](#selenium-firefox-node-selenium-node-firefox) | Selenium grid node (Firefox) |

Details on applying roles to servers can be found in the [Salt administration documentation](admin/salt.md).

## Application server (`app`)

| | |
| --- | --- |
| Dependencies | None |
| Dependants | `app-debug`, `app-gocd-agent` |

Application servers provide the frontend of the environment, serving the site through nginx and handing off dynamic requests to PHP-FPM pools. Each platform is isolated from neighbouring sites using local system user accounts.

### With debugging support (`app-debug`)

| | |
| --- | --- |
| Dependencies | `app` |
| Dependants | None |

This role augments the `app` role with easy access to Behat's faildump and enables debugging and profiling using Xdebug.

The Behat faildump for each platform can be accessed from a browser at `/data/behat-faildump`.

Xdebug profiler output is written to `{home}/data/profiling/` for each platform when enabled. Xdebug can be managed using the following browser extensions:

* [Xdebug Helper](https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc?hl=en) for Chrome

### With blue/green deployments (`app-gocd-agent`)

| | |
| --- | --- |
| Dependencies | `app`, `gocd-agent` |
| Dependants | None |

Extends the `app` role with a series of scripts and configuration for [GoCD](https://www.gocd.io/) that enables upgrades without downtime.

A suite of scripts are installed to `/usr/local/ubiquitous/bin`:

* `ubiquitous-info` - dumps the current configuration for a single site
* `ubiquitous-install-release` - installs a new release
* `ubiquitous-set-current-release` - changes the current release, priming the new release in a secondary FPM pool before switching over to it

These commands depend on platform configuration, stored in `/usr/local/ubiqutous/etc/ubiquitous-platforms` in the following format:

```
domain:basename:username:/home/dir
```

To facilitate running pipelines, the `go` agent user is allowed passwordless `sudo` to the release management commands.

## PostgreSQL database (`db-pgsql`)

| | |
| --- | --- |
| Dependencies | None |
| Dependants | None |

Provides a [PostgreSQL](http://www.postgresql.org/) 9.5 database server with users and databases for each configured platform.

## GoCD agent (`gocd-agent`)

| | |
| --- | --- |
| Dependencies | None |
| Dependants | `app-gocd-agent` |

Installs and configures the [GoCD](https://www.gocd.io/) agent.

## GoCD server (`gocd-server`)

| | |
| --- | --- |
| Dependencies | None |
| Dependants | None |

Installs and configures the [GoCD](https://www.gocd.io/) server.

## Mail debugging (`mail-debug`)

| | |
| --- | --- |
| Dependencies | None |
| Dependants | None |

Installs [MailCatcher](https://mailcatcher.me/), allowing you to review all email sent by Moodle platforms. The SMTP server listens on port 1025, HTTP on 1080.

## Name server (`named`)

| | |
| --- | --- |
| Dependencies | None |
| Dependants | None |

Installs the [Bind]() DNS server, suited for use in internal name resolution.

## Salt master (`salt`)

| | |
| --- | --- |
| Dependencies | None |
| Dependants | None |

Installs the [Salt](https://saltstack.com/) master and appropriate firewall rules.

For installation instructions, see the [administering Salt](admin/salt.md) page.

## Selenium hub (`selenium-hub`)

| | |
| --- | --- |
| Dependencies | None |
| Dependants | None |

Installs the Selenium Grid Hub, which manages sessions across individual browser nodes.

## Selenium Chrome node (`selenium-node-chrome`)

| | |
| --- | --- |
| Dependencies | None |
| Dependants | None |

Installs a Selenium Grid node with ChromeDriver enabled and the latest Chrome release.

## Selenium Firefox node (`selenium-node-firefox`)

| | |
| --- | --- |
| Dependencies | None |
| Dependants | None |

Installs a Selenium Grid node with the latest release of Firefox.

# Understanding Ubiquitous roles

In Ubiquitous, a role is an individual Salt state with a corresponding Salt grain. The following roles are provided:

| Role | Description |
| --- | --- |
| [`app`](#application-server-app) | Application server (PHP, nginx) |
| [`app-debug`](#with-debugging-support-app-debug) | Xdebug debugging and profiling |
| [`app-default-release`](#with-default-release-app-default-release) | Default release configuration for development and integration purposes |
| [`app-error-pages`](#with-custom-error-pages-app-error-pages) | Custom HTTP error pages |
| [`app-gocd-agent`](#with-bluegreen-deployments-app-gocd-agent) | Add-on for application server providing downtime-free deployment scripts for use with GoCD |
| [`app-saml`](#idp-proxy-and-idp-app-saml) | Identity Provider Proxy and test Identity Provider |
| [`app-moodle-debug`](#moodle-debugging) | Behat acceptance testing environment
| [`av-sophos`](#sophos-antivirus-av-sophos) | Sophos Antivirus scanner and realtime protection components |
| [`certbot`](#automated-ssl-certificates-certbot) | Automated SSL certificate issuance and renewal over ACME with Lets Encrypt |
| [`db-pgsql`](#postgresql-database-db-pgsql) | PostgreSQL database server |
| [`gocd-agent`](#gocd-agent-gocd-agent) | Vanilla GoCD agent |
| [`gocd-server`](#gocd-server-gocd-server) | Vanilla GoCD server |
| [`iptables`](#firewall-rules-iptables) | Manage custom firewall rules |
| [`mail-debug`](#mail-debugging-mail-debug) | Trap outbound email with MailCatcher |
| [`mail-relay`](#mail-relay-mail-relay) | Relay mail to an SMTP server for external delivery |
| [`mount-cifs`](#cifs-shares-mount-cifs) | Mount remote CIFS shares |
| [`named`](#name-server-named) | Bind DNS server |
| [`redis`](#redis-redis) | Redis master and slave instances |
| [`salt`](#salt-master-salt) | Salt master for configuration management |
| [`selenium-hub`](#selenium-hub-selenium-hub) | Selenium grid hub server |
| [`selenium-node-chrome`](#selenium-chrome-node-selenium-node-chrome) | Selenium grid node (Chrome) |
| [`selenium-node-firefox`](#selenium-firefox-node-selenium-node-firefox) | Selenium grid node (Firefox) |

Details on applying roles to servers can be found in the [Salt administration documentation](salt.md).

## Application server (`app`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | `app-debug`, `app-gocd-agent` | None |

Application servers provide the frontend of the environment, serving the site through nginx and handing off dynamic requests to PHP-FPM pools. Each platform is isolated from neighbouring sites using local system user accounts.

### With debugging support (`app-debug`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| `app-base` | None | None |

Enables remote debugging and profiling using Xdebug.

### With default release (`app-default-release`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| `app-base` | None | `app-gocd-agent` |

Allows administrators to configuration manage the active release rather than assuming a dedicated deployment tool.

### With custom error pages (`app-error-pages`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| `app-base` | None | None |

Allows branding error pages.

### With blue/green deployments (`app-gocd-agent`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| `app-base`, `gocd-agent` | None | `app-default-release` |

Extends the `app` role with a series of scripts and configuration for [GoCD](https://www.gocd.io/) that enables upgrades without downtime.

## IDP Proxy and IDP (`app-saml`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| `app-base` | None | None |

Installs and configures a SimpleSAMLphp identity provider proxy (and optional identity provider).

## Moodle (`app-moodle`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| `app-base` | None | None |

Installs and configures a Moodle site.

## Moodle debugging (`app-moodle-debug`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| `app-debug` | None | None |

Extends the `app-debug` role with moodle specific configuration. Adds an alias for the Moodle environment (required for Behat), provides easy access to the Behat fail dump.

## Sophos Antivirus (`av-sophos`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | None | None |

Installs and configures the Sophos one-time scanner and realtime protection components.

## Automated SSL certificates (`certbot`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | None | None |

Makes available the `certbot` command, required for automated certificate issuance with Lets Encrypt.

## PostgreSQL database (`db-pgsql`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | None | None |

Provides a [PostgreSQL](http://www.postgresql.org/) 9.5 database server with users and databases for each configured platform.

## GoCD agent (`gocd-agent`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | `app-gocd-agent` | None |

Installs and configures the [GoCD](https://www.gocd.io/) agent.

## GoCD server (`gocd-server`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | None | None |

Installs and configures the [GoCD](https://www.gocd.io/) server.

## Firewall rules (`iptables`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | None | None |

Allows configuring custom iptables rules.

## Mail debugging (`mail-debug`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | None | None |

Installs [MailCatcher](https://mailcatcher.me/), allowing you to review all email sent by Moodle platforms. The SMTP server listens on port 1025, HTTP on 1080.

## Mail relay (`mail-relay`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | None | None |

Relay email to a remote SMTP server for delivery.

## CIFS shares (`mount-cifs`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | None | None |

Mount CIFS shares on remote servers.

## Name server (`named`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | None | None |

Installs the [Bind](https://www.isc.org/downloads/bind/) DNS server, suited for use in internal name resolution, and configures zones.

## Redis (`redis`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | None | None |

Installs and configures a [redis](https://redis.io/) server and two redis slave instances.

## Salt master (`salt`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | None | None |

Installs the [Salt](https://saltstack.com/) master and appropriate firewall rules.

For installation instructions, see the [administering Salt](salt.md) page.

## Selenium hub (`selenium-hub`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | None | None |

Installs the Selenium Grid hub, which manages sessions across individual browser nodes.

## Selenium Chrome node (`selenium-node-chrome`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | None | `selenium-node-firefox` |

Installs a Selenium Grid node with ChromeDriver enabled and the latest Chrome release.

## Selenium Firefox node (`selenium-node-firefox`)

| Dependencies | Dependants | Conflicts |
| --- | --- | --- |
| None | None | `selenium-node-chrome` |

Installs a Selenium Grid node with the latest release of Firefox.

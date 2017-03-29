# Ubiquitous Moodle

A sample [Moodle](https://moodle.org) configuration, targeted at developers.

It employs [Vagrant](https://www.vagrantup.com) to provision environments, [Salt](https://docs.saltstack.com/en/getstarted/) for configuration management, and [GoCD](https://www.gocd.io/) for continuous delivery.

The environment includes:

* [Ubuntu 16.04.2 LTS](https://www.ubuntu.com/)
* Static file serving with [nginx](http://nginx.org/)
* [PHP 7.0](http://php.net/), with the FPM SAPI and OPcache
* [PostgreSQL 9.5](http://www.postgresql.org/)
* [Selenium](http://www.seleniumhq.org/) Hub and nodes

## Usage

Ubiquitous aims to cover the requirements of both [Moodle developers](docs/using/in-development.md) and [production Moodle deployments](docs/using/in-production.md).

In both configurations, Salt applies configuration changes to the servers. The difference is in which servers are enabled and which [server roles](docs/roles.md) are applied to them.

### Getting Started
See [in-development](docs/using/in-development.md), assuming you're running a development box.

* * *

## License

Ubiquitous Moodle is released under the terms of the GPL v3. This is the same license as the core Moodle distribution.

## Development

Documentation for Ubiquitous developers is in the works.


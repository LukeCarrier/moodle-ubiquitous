# Ubiquitous Moodle

A sample [Moodle](https://moodle.org) configuration, targeted at developers.

It employs [Vagrant](https://www.vagrantup.com) to provision environments, [Salt](https://docs.saltstack.com/en/getstarted/) for configuration management, and [GoCD](https://www.gocd.io/) for continuous delivery.

The environment includes:

* [Ubuntu 16.04.2 LTS](https://www.ubuntu.com/)
* Configuration management with [Salt](https://docs.saltstack.com/en/getstarted/)
* Continuous delivery with [GoCD](https://www.gocd.io/)
* Static file serving with [nginx](http://nginx.org/)
* [PHP 7.0](http://php.net/), with the FPM SAPI and OPcache
* [PostgreSQL 9.5](http://www.postgresql.org/)
* [Selenium](http://www.seleniumhq.org/) Hub and nodes


## Documentation

For detailed instructions on how to get started with Ubiquitous, please see [the manual](https://lukecarrier.gitbooks.io/ubiquitous-moodle/).

## Usage

Ubiquitous aims to cover the requirements of:
* [Moodle development](docs/getting-started/development) - using [Vagrant](https://www.vagrantup.com/)
* [Moodle testing / Continuous Integration](docs/getting-started/test) - using [Docker](https://www.docker.com/)
* [production Moodle deployments](docs/getting-started/production) - using your tool of choice.

In all use cases, Salt applies configuration changes to the servers. The difference is in which servers are enabled and which [server roles](docs/roles) are applied to them.

### Getting Started
See [in-development](ddocs/getting-started/development), assuming you're running a development box.

## Ubiquitous Development

Documentation for Ubiquitous developers is in the works.

* * *

## License

Ubiquitous Moodle is released under the terms of the [GPL v3](LICENSE.md). This is the same license as the core Moodle distribution.


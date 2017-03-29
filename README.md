# Ubiquitous Moodle

A sample Moodle configuration for both development and production deployment comprised of:

* [Ubuntu 16.04.2 LTS](https://www.ubuntu.com/)
* Configuration management with [Salt](https://docs.saltstack.com/en/getstarted/)
* Static file serving with [nginx](http://nginx.org/)
* [PHP 7.0](http://php.net/), with the FPM SAPI and OPcache
* [PostgreSQL 9.5](http://www.postgresql.org/)
* Continuous delivery with [GoCD](https://www.gocd.io/)
* [Selenium](http://www.seleniumhq.org/) Hub and nodes

[More about server roles...](docs/roles.md)

* * *

## License

Ubiquitous Moodle is released under the terms of the GPL v3. This is the same license as the core Moodle distribution.

## Usage

Ubiquitous aims to cover numerous use cases with the same Salt state tree. In each use case, the tooling used to manage machines and the distribution of roles across these machines differs:

* Vagrant is used in [local Moodle development environments](docs/using/in-development.md)
* Docker containers are built for use in [continuous integration platforms](docs/using/in-test.md)
* Your tool of choice in [production Moodle deployments](docs/using/in-production.md).

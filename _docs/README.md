# Ubiquitous Moodle

Ubiquitous is a multi-purpose [Moodle](https://moodle.org/) and [SimpleSAMLphp](https://simplesamlphp.org/) hosting environment.

It fulfils three requirements:

1. _Provisioning_ of machines with either a container or virtualisation platform
    * In local development environments we manage [VirtualBox](https://www.virtualbox.org/) virtual machines with [Vagrant](https://www.vagrantup.com/).
    * Continuous integration platforms run on purpose-built [Docker](https://www.docker.com/) containers.
    * Production deployments can use your tool of choice.
2. _Configuration management_ across these machines
3. _Continuous integration_ to ensure your platforms will run correctly once deployed
4. _Continuous delivery_ of your platforms to the machines.

The environment is designed to simplify the Moodle development experience and provide a consistency across development, testing/integration and production.

---

## Specifications

The technical specifications of the environment are as follows:

* [Ubuntu 16.04.2 LTS](https://www.ubuntu.com/)
* Configuration management with [Salt](https://saltstack.com/)
* Continuous delivery with [GoCD](https://www.gocd.org/)
* Static file serving with [nginx](http://nginx.org/)
* [PHP](http://php.net/), with the FPM SAPI and OPcache
* [PostgreSQL 9.5](http://www.postgresql.org/)
* [Selenium](http://www.seleniumhq.org/) Hub and nodes

## License

Ubiquitous Moodle is released under the terms of the GPL v3. This is the same license as the core Moodle distribution.

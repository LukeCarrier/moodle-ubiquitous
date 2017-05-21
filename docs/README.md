# Ubiquitous Moodle

Ubiquitous is a multi-purpose Moodle hosting environment.

It fulfils three requirements:

1. _Provisioning_ of machines with either a container or virtualisation platform.
    * In local development environments we manage [VirtualBox](https://www.virtualbox.org/) virtual machines with [Vagrant](https://www.vagrantup.com/)
    * Continuous integration platforms run on purpose-built [Docker](https://www.docker.com/) containers
    * Production deployments can use your tool of choice
2. _Configuration management_ across these machines.
3. _Continuous integration_ to ensure your platforms will run correctly once deployed.
4. _Continuous delivery_ of your platforms to the machines.

The environment is designed to simplify the Moodle development experience and provide a consistency across development, testing/integration and production.

---

## Specifications

The technical specifications of the environment are as follows:

* [Ubuntu 16.04.2 LTS](https://www.ubuntu.com/)
* Configuration management with [Salt](https://saltstack.com/)
* Continuous delivery with [GoCD](https://www.gocd.io/)
* Static file serving with [nginx](http://nginx.org/)
* [PHP 7.0](http://php.net/), with the FPM SAPI and OPcache
* [PostgreSQL 9.5](http://www.postgresql.org/)
* [Selenium](http://www.seleniumhq.org/) Hub and nodes

## Developing Ubiquitous

A rudimentary understanding of Salt concepts is essential: Ubiquitous is just an ordinary Salt state tree. The [Get Started tutorials](https://docs.saltstack.com/en/getstarted/) and ["Salt in ten minutes" walkthrough](https://docs.saltstack.com/en/latest/topics/tutorials/walkthrough.html) are great starting points.

### Building the documentation

The documentation is managed with the excellent [GitBook toolchain](https://toolchain.gitbook.com/) and hosted by [GitBook](https://www.gitbook.com/). To work with it locally:

```
# Install the dependencies
$ npm install

# Launch the server -- use this when making changes
$ npm run gitbook -- serve

# Or perform a one-time build to _book/
$ npm run gitbook -- build
```

## License

Ubiquitous Moodle is released under the terms of the GPL v3. This is the same license as the core Moodle distribution.

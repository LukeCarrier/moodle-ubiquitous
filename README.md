# Ubiquitous Moodle

A sample Moodle configuration for both development and production deployment comprised of:

* [Ubuntu 16.04.2 LTS](https://www.ubuntu.com/)
* Configuration management with [Salt](https://docs.saltstack.com/en/getstarted/)
* Continuous delivery with [GoCD](https://www.gocd.io/)
* Static file serving with [nginx](http://nginx.org/)
* [PHP 7.0](http://php.net/), with the FPM SAPI and OPcache
* [PostgreSQL 9.5](http://www.postgresql.org/)
* [Selenium](http://www.seleniumhq.org/) Hub and nodes

An add-on single sign-on experience comprised of:

* Identity provider proxy with [SimpleSAMLphp](https://simplesamlphp.org/)
* Identity provider with [SimpleSAMLphp](https://simplesamlphp.org/)
* Optional data storage [Redis](https://redis.io/) Master and slave instances

---

## Status

[![Docker Build Status](https://img.shields.io/docker/build/lukecarrier/moodle-ubiquitous.svg?style=flat-square)](https://hub.docker.com/r/lukecarrier/moodle-ubiquitous/)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bhttps%3A%2F%2Fgithub.com%2FLukeCarrier%2Fmoodle-ubiquitous.svg?type=shield)](https://app.fossa.io/projects/git%2Bhttps%3A%2F%2Fgithub.com%2FLukeCarrier%2Fmoodle-ubiquitous?ref=badge_shield)

## Documentation

For detailed instructions on how to get started with Ubiquitous, please see [the manual](https://lukecarrier.gitbooks.io/ubiquitous-moodle/).

## License

Ubiquitous Moodle is released under the terms of the [GPL v3](LICENSE.md). This is the same license as the core Moodle distribution.

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bhttps%3A%2F%2Fgithub.com%2FLukeCarrier%2Fmoodle-ubiquitous.svg?type=large)](https://app.fossa.io/projects/git%2Bhttps%3A%2F%2Fgithub.com%2FLukeCarrier%2Fmoodle-ubiquitous?ref=badge_large)

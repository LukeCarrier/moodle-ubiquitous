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

Ubiquitous aims to cover the requirements of both [Moodle developers](docs/using/in-development.md) and [production Moodle deployments](docs/using/in-production.md). In both configurations, Salt applies configuration changes to the servers. The difference is in which servers are enabled and which [roles](docs/roles.md) are applied to them.

## Development

Developer documentation is in the works.

## Testing

We've got you covered. A complete end-to-end test of the setup process can be achieved easily with Vagrant, just:

```
# Bring up all of the machines, installing and configuring Salt for later

# provisioning
$ vagrant up

# Fetch necessary binaries from the Internet; they're all checksummed on their
# way in :)
$ ./make-cache

# Provision the Salt master first, opening the ports necessary for
# master-minion configuration
$ vagrant ssh --command "sudo salt salt state.apply"

# Then converge the rest of the machines
$ vagrant ssh --command "sudo salt '*' state.apply"
```

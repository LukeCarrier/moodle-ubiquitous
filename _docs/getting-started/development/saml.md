# Using Ubiquitous for SimpleSAMLphp development

Ubiquitous expects the following directory structure for the synced folders it configures with the application servers:

```
.
├── SimpleSAMLphp-provider
├── SimpleSAMLphp-proxy
└── Ubiquitous
```

Start up all of the machines necessary for a development environment:

```
$ vagrant up salt
$ vagrant group up saml
```

The first time you start the servers, and whenever you make changes to the Salt states, you'll need to apply the states to the machines:

```
# Provision the Salt master first, opening the ports necessary for
# master-minion configuration
$ vagrant ssh --command 'sudo salt-call state.apply'

# Then converge the rest of the machines
$ vagrant group ssh saml --command 'sudo salt-call state.apply'
```

Once complete, the following services should be available to you. Note that the sites will return 500 Internal Server Error statuses without their configuration installed --- see `scp` instructions below for details:

* [Identity provider](http://192.168.120.55/)
* [Identity provider proxy](http://192.168.120.60/)

To use the Salt-generated configuration, you'll want to `scp` it from the box, copy it into your SimpleSAMLphp installation and then sync the installation back to the machine. You'll want to repeat the following instructions for each of the application servers (`identity-provider`, `identity-proxy`):

```bash
$ vagrant ssh salt -c 'sudo salt -l debug identity-proxy state.apply'
$ rm -rf ../conf-proxy
$ vagrant scp identity-proxy:conf ../conf-proxy
$ rsync -avr ../conf-proxy/* ../SimpleSAMLphp-proxy/
$ vagrant rsync identity-proxy
```

## Identity Provider

The `identity-provider` machine provides a SimpleSAMLphp instance configured with its own local `example:userpass` authentication source, and the SP metadata of the Identity Provider Proxy.

### Credentials

Test credentials are stored in the `authsources.php` file in the form of a multidimensional array, keyed with the username and password delimited by a colon (`:`). The values of that key is an array with the following information:

* `Login`
* `FirstName`
* `LastName`
* `Email`

## Identity Provider Proxy

In this configuration, SimpleSAMLphp proxies claims from an IdP (in this case, `identity-provider`) to an SP (Moodle, after you install a compatible plugin and exchange the IdP and SP metadata).

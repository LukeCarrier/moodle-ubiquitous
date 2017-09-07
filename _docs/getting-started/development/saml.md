# Using Ubiquitous for SimpleSAMLphp development

## Getting started

The Vagrant environment comprises the following machines:

* `identity-provider`
* `identity-proxy`

Each expects the presence of a SimpleSAMLphp installation:

```
.
├── SimpleSAMLphp-provider
├── SimpleSAMLphp-proxy
└── Ubiquitous
```

To use the Salt-generated configuration, you'll want to `scp` it from the box, copy it into your SimpleSAMLphp installation and then sync the installation bac to the machine:

```bash
$ vagrant ssh salt -c "sudo salt -l debug identity-proxy state.apply"
$ rm -rf ../conf-proxy
$ vagrant scp identity-proxy:conf ../conf-proxy
$ rsync -avr ../conf-proxy/* ../SimpleSAMLphp-proxy/
$ vagrant rsync identity-proxy
```

## Identity Provider

### Credentials

Test credentials are stored in the `authsources.php` file in the form of a multidimensional array, keyed with the username and password delimited by a colon (`:`). The values of that key is an array with the following information:

* `Login`
* `FirstName`
* `LastName`
* `Email`

## Identity Provider Proxy

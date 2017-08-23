# Saml

[SimpleSAMLphp](https://simplesamlphp.org/docs/stable/) is used to enable a single sign on experience on the learning platforms. Configured as an Identity Provider Proxy, the IDP sits between the learning platforms and the identity providers of our integrated customers to enable a hassle free authentication experience. 

The `app-saml` role contains all necessary configuration steps to create an identity provider proxy (IDP Proxy or `IDPP`) as well as an identity provider (IDP) to test the authentication against. Both, the IDPP and the IPD are using [SimpleSAMLphp](https://simplesamlphp.org/docs/stable/).

## Configuration management

The salt states provided create a configuration folder `conf` in the users home folder. All configuration files necessary for the saml applications to run, including certificates, metadata and module configuration will end up there. 

### Necessary local folders

The vagrant setup for the SimpleSAMLphp application servers assume a few folders to exist.

```
.
├── Moodle
├── SimpleSAMLphp-IdP
├── SimpleSAMLphp-proxy
├── conf-idp
└── conf-proxy
```

The final folder structure will be looking something like this: 

```bash
.
├── cert
│   ├── saml.cert
│   └── saml.pem
├── config
│   ├── authsources.php
│   └── config.php
├── metadata
│   ├── saml20-idp-hosted.php
│   └── saml20-sp-remote.php
└── modules
    └── exampleauth
        └── enable
```

### Synchronising configuration files

After running the salt states, you want to synchronise the configuration files into the shared folder of your saml installation.

Example state apply and configuration file synchronisation all in one: 

```bash
$ vagrant ssh salt -c "sudo salt -l debug identity-proxy state.apply" && rm -rf ../conf-proxy && vagrant scp identity-proxy:conf ../conf-proxy && rsync -avr ../conf-proxy/* ../SimpleSAMLphp-proxy/ && vagrant rsync identity-proxy
```

Breaking down the above's command: 

Run the states against the identity proxy from the salt master with debug output: 

```bash
$ vagrant ssh salt -c "sudo salt -l debug identity-proxy state.apply"
```

Remove the local configuration folder to ensure that all files are synced freshly from the applied states:

```bash
$ rm -rf ../conf-proxy
```

Pull down the configuration files from the identity proxy box and re-create the configuration folder: 

```bash
$ vagrant scp identity-proxy:conf ../conf-proxy
```

Rsync the configuration files into your local application folder which is used to provide the application installation files: 

```bash
$ rsync -avr ../conf-proxy/* ../SimpleSAMLphp-proxy/
```

Rsync the application files onto your vagrant box: 

```bash
$ vagrant rsync identity-proxy
```

## Setup

SimpleSAMLphp relies on a few modules to be installed through composer. From within both of the SimpleSAMLphp application folders, run:

```bash
$ wget https://getcomposer.org/composer.phar
$ php composer.phar install
```

## IDP Proxy

The IDP proxy acts as bridge between the learning platform and the identity provider, handling request from the users which are trying to log into the learning platform via single sign on and managing the authentication / login process with the identity provider. The test setup assumes a working moodle site with `saml` enabled as way of authentication.

*TL;DR*

The IDP proxy is both, service provider (to the identity provider) and identity provider (to the learning platform).

### Configuration files

All file paths are relative to the SimpleSAMLphp installation directory.

* `config/authsources.php`
* `config/module_redis.php`
* service provider ssl `.cert` and `.pem` under `cert/`
* identity provider ssl `.cert` and `.pem` under `cert/`
* `metadata/saml20-idp-hosted.php`
* `metadata/saml20-idp-remote.php`
* `metadata/saml20-sp-remote.php`
* `enable` files to enable the exampleauth and redis modules
    * `modules/exampleauth/enable`
    * `modules/redis/enable`

#### Modules

Modules can be configured through the salt pillar. The following modules currently have a templated configuration: 

* exampleauth
* redis

##### Example configuration

```yaml
platforms:
    example.org:
        saml:
            modules:
                exampleauth: True
                redis: True
```

> Note that if you are enable / disable a module, you will also have to add/remove the relevant module configuration in the pillar.

### Requirements

To fully function and be able to store the browser sessions, the IDP proxy requires a data store to save the data.
One option to use as data store is Redis, for which we have a [role here](../redis.md).

## Identity Provider

The identity provider is a SimpleSAMLphp server providing a set of test accounts to verify the authentication process.

### Configuration files

All file paths are relative to the SimpleSAMLphp installation directory.

* `config/authsources.php`
* identity provider ssl `.cert` and `.pem` under `cert/`
* `metadata/saml20-sp-remote.php`
* `modules/exampleauth/enable`

#### Modules

Modules can be configured through the salt pillar. The following modules currently have a templated configuration: 

* exampleauth

### Credentials

Test credentials are stored in the `authsources.php` file in the form of an array of arrays.

The array is keyed with the `username` and `password`. The values of that key is an array with the following information:

* `Login`
* `FirstName`
* `LastName`
* `Email`

## Troubleshooting

### Caused by: Exception: Unable to validate Signature

Potential causes:

* Sometimes the meta data on the identity provider refreshes - update the metadata of the identity provider on the service provider side (identity proxy)

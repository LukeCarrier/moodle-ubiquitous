# Saml

[SimpleSAMLphp](https://simplesamlphp.org/docs/stable/) is used to enable a single sign on experience on the learning platforms. Configured as an Identity Provider Proxy, the IDP sits between the learning platforms and the identity providers of our integrated customers to enable a hassle free authentication experience. 

The `app-saml` role contains all necessary configuration steps to create an identity provider proxy (IDP Proxy or `IDPP`) as well as an identity provider (IDP) to test the authentication against. Both, the IDPP and the IPD are using [SimpleSAMLphp](https://simplesamlphp.org/docs/stable/).

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

# Summary

## Overview

* [Introduction](README.md)

## Getting started

* [Introduction](getting-started/README.md)
* [For development](getting-started/development/README.md)
    * [Of Moodle](getting-started/development/moodle.md)
    * [Of SimpleSAMLphp](getting-started/development/saml.md)
* [In test/integration](getting-started/test.md)
* [In production](getting-started/production.md)

## Workloads

* [High availability NFS](workloads/ha-nfs.md)

## Roles

* [Salt](roles/salt.md)
* [GoCD agent and server](roles/gocd.md)
* [Application servers](roles/app/README.md)
    * [Moodle](roles/app/moodle.md)
    * [SAML](roles/app/saml.md)
    * Addons
        * [Error pages](roles/app/addons/error-pages.md)
        * [GoCD agent](roles/app/addons/gocd-agent.md)
        * [Let's Encrypt](roles/app/addons/lets-encrypt.md)
        * [SSL certificates](roles/app/addons/ssl-certs.md)
* [PostgreSQL](roles/postgresql.md)
* [Redis](roles/redis.md)
* [MailCatcher](roles/mailcatcher.md)
* [nftables](roles/nftables.md)
* [CIFS mounts](roles/mount-cifs.md)
* [BIND](roles/named.md)
* [Postfix](roles/postfix.md)
* [Selenium](roles/selenium.md)
* [systemd](roles/systemd.md)

## Developing Ubiquitous

* [Introduction](development/README.md)
* [Docker](development/docker.md)
* [Documentation](development/docs.md)
* [Testing](development/tests.md)

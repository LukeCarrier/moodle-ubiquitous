# Ubiquitous Salt pillar values

[The Salt pillar](https://docs.saltstack.com/en/latest/topics/tutorials/pillar.html) provides a home for configuration data that doesn't belong within the Salt state tree, enabling developers to create more reusable states.

This document provides an overview of the available pillar values and where they're used. A complete sample of the pilalr tree, with relevant top file, can be found in the [Vagrant configuration](../vagrant/salt/pillar).

## `admin`

Details about the administrative user, who'll be able to log in to the server via SSH.

```
admin:
  # Required
  name: ubuntu           # Username
  password: gibberish    # Cleartext for now
  groups:                # Primary group is always named after user name
    - sudo               # Recommended to enable elevation
  home: /home/ubuntu     # Home directory

  # Optional
  authorized_keys:       # SSH keys for authentication
    - ssh-rsa <public key>
```

## `gocd-agent`

Configuration for the GoCD agent.

```
gocd-agent:
  # Required
  server: https://192.168.120.10:8154/go    # Where agents should register
```

## `gocd-deploy`

Deployment-specific GoCD agent configuration.

```
gocd-deploy:
  known-hosts:
    - <.ssh/known_hosts entry>
    - <.ssh/known_hosts entry>
  identities:
    id_rsa: |
    -----BEGIN RSA PRIVATE KEY-----
    <private key>
    -----END RSA PRIVATE KEY-----
    id_rsa_other: |
    -----BEGIN RSA PRIVATE KEY-----
    <private key>
    -----END RSA PRIVATE KEY-----
```

## `gocd-server`

GoCD server configuration.

```
gocd-server:
  # Optional
  users:    # Who can authenticate
    lcarrier: sumK1vbrhQjdahTPpwS61/Bfb7E=
```

## `nginx`

Web server configuration.

## `platforms`

## `system:home_directories`

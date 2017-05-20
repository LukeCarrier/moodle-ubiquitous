# Ubiquitous Salt pillar values

[The Salt pillar](https://docs.saltstack.com/en/latest/topics/tutorials/pillar.html) provides a home for configuration data that doesn't belong within the Salt state tree, enabling developers to create more reusable states.

This document provides an overview of the available pillar values and where they're used. A complete sample of the pillar tree, with relevant top file, can be found in the [Vagrant configuration](../vagrant/salt/pillar).

## `acl`

Application of access control lists to home directories.

```yaml
acl:
  # Required
  apply: True    # Should ACLs be applied?
```

## `users`

Details about the administrative users, who'll be able to log in to the server via SSH.

```yaml
users:
  # Required
  ubuntu:                  # Username
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

```yaml
gocd-agent:
  # Required
  server: https://192.168.120.10:8154/go    # Where agents should register
```

## `gocd-deploy`

Deployment-specific GoCD agent configuration.

```yaml
gocd-deploy:
  # Optional
  known-hosts:    # Known hosts entries for host authentication
    - '<.ssh/known_hosts entry>'
    - '<.ssh/known_hosts entry>'
  identities:     # SSH identities for user authentication
    id_rsa: |
      -----BEGIN RSA PRIVATE KEY-----
      # a private key
      -----END RSA PRIVATE KEY-----
    id_rsa_other: |
      -----BEGIN RSA PRIVATE KEY-----
      # another private key
      -----END RSA PRIVATE KEY-----
```

## `gocd-server`

GoCD server configuration.

```yaml
gocd-server:
  # Optional
  users:                                      # Who can authenticate (username, SHA1 hash of password)
    lcarrier: sumK1vbrhQjdahTPpwS61/Bfb7E=    # "Password123"
```

## `iptables`

Firewall configuration application.

```yaml
iptables:
  # Required
  apply: True    # Should iptables rules be applied?
```

## `locales`

Localisation configuration for the `locales` package and supporting tools.

```yaml
locales:
  # Required
  present:                # Installed locales
    - en_AU.UTF-8
    - en_GB.UTF-8
    - en_US.UTF-8
  default: en_GB.UTF-8    # Default locale
```

## `nginx`

Web server configuration.

```yaml
nginx:
  # Required
  user: www-data    # User and group nginx should run as
```

## `platforms`

```yaml
platforms:
  # Variable number of platforms
  dev.local:                                                       # Domain name
    basename: ubuntu                                               # Basename for configuration files
    user:
      name: ubuntu                                                 # Owning local user account
      home: /home/ubuntu                                           # Home directory
    nginx:
      client_max_body_size: 1024m                                  # Maximum request payload size
    php:
      fpm:                                                         # FastCGI Process Manager
        pm: dynamic                                                # Process management mode
        pm.max_children: 10                                        # Maximum child processes
        pm.start_servers: 5                                        # Child processes to start
        pm.min_spare_servers: 5                                    # Minimum idle servers
        pm.max_spare_servers: 5                                    # Maximum idle servers
        pm.max_requests: 1000                                      # Maximum requests per child
      values:                                                      # PHP runtime configuration
        memory_limit: 1024m                                        # Memory limit
        post_max_size: 1024m                                       # Maximum request payload size
        upload_max_filesize: 1024m                                 # Maximum size of single uploaded file
        session.save_handler: files                                # Session storage
        session.save_path: /home/ubuntu/var/run/php/session        # Session storage location
        soap.wsdl_cache_dir: /home/ubuntu/var/run/php/wsdlcache    # WSDL cache directory
      pgsql:
        user:
          name: ubuntu                                             # Username
          password: gibberish                                      # Password
        database:
          name: ubuntu                                             # Database name
          encoding: utf8                                           # Database encoding
      moodle:
        dbtype: pgsql                                              # Database type
        dblibrary: native                                          # Database library
        dbhost: 192.168.120.150                                    # Database host
        dbname: ubuntu                                             # Database name
        dbuser: ubuntu                                             # Database user
        dbpass: gibberish                                          # Database password
        prefix: mdl_                                               # Database table prefix
        dboptions:
          dbpersist: False                                         # Use persistent connections?
          dbport: 5432                                             # Database port
          dbsocket:                                                # Database socket
        dataroot: /home/ubuntu/data                                # Moodle data directory
        directorypermissions: '0777'                               # Data directory permissions
        wwwroot: http://192.168.120.50                             # Moodle base URL
        sslproxy: false                                            # Assume SSL terminated on load balancer
        admin: admin                                               # Administration directory
```

## `PostgreSQL`

PostgreSQL database server and client authentication configuration.

```yaml
postgresql:
  # Required
  client_authentication:           # Client authentication entries for pg_hba.conf
    - type: host
      database: all
      user: all
      address: 192.168.120.0/24
      method: md5
```

## `system`

General system configuration.

```yaml
system:
  # Required
  home_directories:    # Home directories
    - /home
```

## `systemd`

systemd and service management configuration.

```yaml
systemd:
  # Required
  apply: True
```

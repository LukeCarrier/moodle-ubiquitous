# Application servers

Application servers run an HTTP server ([nginx](https://nginx.org/) 1.10.x) and dispatch dynamic requests to [PHP-FPM](http://php.net/manual/en/install.fpm.php) 7.0.x. They can host one or more platforms.

## Home directories and filesystem ACLs

All source and data files for each platform are owned by separate user accounts, simplifying administration and providing a degree of isolation in the event that an application server is compromised. Whilst PHP-FPM pools and PHP worker processes will always run as these users, nginx (running as pillar `nginx:user`) needs read access to the document root to serve static files.

This role requires that all filesystems containing platform home directories (pillar `system:home_directories`) have support for Linux ACLs. You can verify that support is enabled as follows:

```
# Checking the active mount --- proceed to the defaults if they're enabled for
# the mount
$ mount | grep 'on / type'

# Checking defaults
# Pull requests for additional filesystems welcome ;-)
$ tune2fs /dev/xxx | grep 'Default mount options'    # ext* filesystems
```

## Platforms

A "platform" is an individual Moodle or SimpleSAMLphp site, its corresponding local user account, nginx `server {}` and its PHP-FPM `[pool]`. Individual application servers can serve multiple platforms. The list of platforms to be installed on each application server is determined based on the contents of the Salt pillar `platforms`, allowing variable allocation of platforms using the Salt top file.

Per-platform user accounts contain a directory structure like the following:

```
.
├── current     # Symlink to current release
└── releases    # Release directory
```

The nginx configuration follows the Debian convention, with per-platform configuration stored in `/etc/nginx/sites-available`. These configuration files are symlinked to `/etc/nginx/sites-enabled`, where nginx sources _enabled_ site configuration. Each platform will also source additional configuration from `/etc/nginx/sites-extra/<platform basename>.*.conf`.

The PHP-FPM configuration emulates this configuration. Configuration files are stored in `/etc/php/7.0/fpm/pools-available` and linked to `/etc/php/7.0/fpm/pools-enabled`. Each pool sources additional configuration from `/etc/php/7.0/fpm/pools-extra`.

This configuration facilitates blue/green deployments by simply adding links and reloading the appropriate service.

You can determine which platforms will be deployed to a given application server by querying the Salt pillar:

```
$ salt <minion ID> pillar.keys platforms
```

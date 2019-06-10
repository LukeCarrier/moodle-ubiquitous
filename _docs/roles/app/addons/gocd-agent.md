# GoCD agent configuration

The `app-gocd-agent` role maintains a number of scripts that facilitate the deployment process, enabling continuous delivery.

## The scripts

All of the scripts are installed `/usr/local/ubiquitous/bin`:

* `ubiquitous-info` helps administrators understand the running state of a platform by describing the current configuration. It does so by examining three symbolic links:
  * The active nginx `server {}` entry in `/etc/nginx/sites-enabled.d`.
  * The active PHP-FPM pool entry in `/etc/php-fpm/pools-enabled.d`.
  * The `current` symlink in the user's home directory.
* `ubiquitous-install-release` copies new source files into a release directory ready for switching over.
* `ubiquitous-set-current-release` changes the active release by enabling the inactive FPM pool before altering each of the symbolic links and reloading the services as necessary.

These scripts use a configuration file maintained by the Salt states that describes the platforms installed on the application server. The format of `/usr/local/ubiquitous/etc/ubiquitous-platforms` is as follows:

```
<domain>:<basename>:<username>:<home>
```

## Security and sudoers

In order to reload service configuration, the `go` user must be able to escalate its privileges. The `admin` state can be used to `sudo` for passwordless sudo:

```yaml
sudoers:
  gocd:
    - '%go ALL=(ALL) NOPASSWD: /usr/bin/salt-call ubiquitous_platform.*'
```

## Sample configuration

An example GoCD pipeline configuration for use with the Vagrant environment is provided in the [`/_vagrant/gocd` directory](https://github.com/LukeCarrier/moodle-ubiquitous/tree/master/_vagrant/gocd). You can apply this by editing the `cruise-config.xml` file and restarting the `go-server` service.

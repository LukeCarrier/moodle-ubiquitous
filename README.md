# Ubiquitous Moodle

A work in progress sample Moodle configuration comprised of:

* Configuration management with [Salt](https://docs.saltstack.com/en/getstarted/)
* Static file serving with [nginx](http://nginx.org/)
* [PHP 5.6](http://php.net/), with the FPM SAPI and OPcache
* [PostgreSQL 9.4](http://www.postgresql.org/)

* * *

## License

Ubiquitous Moodle is released under the terms of the GPL v3. This is the same
license as the core Moodle distribution.

## Network configuration

For the purposes of this guide, we're assuming the following configuration. To
simplify your configuration, just do a find/replace on this document with your
details.

### IP addresses

| IP address        | Hostname                       | Server role                     |
| ----------------- | ------------------------------ | ------------------------------- |
| `192.168.120.5`   | `salt.moodle`                  | Salt master                     |
| `192.168.120.50`  | `app-debug-1.moodle`           | Application server (with debug) |
| `192.168.120.100` | `selenium-hub.moodle`          | Selenium grid hub               |
| `192.168.120.105` | `selenium-node-chrome.moodle`  | Selenium node (Chrome)          |
| `192.168.120.110` | `selenium-node-firefox.moodle` | Selenium node (Firefox)         |
| `192.168.120.150` | `db-1.moodle`                  | PostgreSQL server               |
| `192.168.120.200` | `mail-debug.moodle`            | Mail catcher                    |

### Configuration values

| Configuration item                 | Value                                             |
| ---------------------------------- | ------------------------------------------------- |
| Administrative user                | `admin`                                           |
| Salt master public key fingerprint | `3e:91:ad:e7:be:1f:63:16:c2:be:60:2b:7d:d5:f8:42` |

## Known issues

* Until [this bug](https://github.com/saltstack/salt/issues/27435) is fixed,
  `firewalld` zones will not be configured correctly. Run the following commands
  manually to resolve these issues:
    * `salt`: `$ sudo firewall-cmd --permanent --zone=public --add-service=salt-master && sudo firewall-cmd --reload`
    * `app-debug-1`: `$ sudo firewall-cmd --permanent --zone=public --add-service=http && sudo firewall-cmd --reload`
    * `db-1`: `$ sudo firewall-cmd --permanent --zone=public --add-service=postgresql && sudo firewall-cmd --reload`

## Future tasks

* Configure the Salt master to run in a [non-root configuration](https://docs.saltstack.com/en/latest/ref/configuration/nonroot.html).
* Allow updating Salt minion configuration from a template on each machine and
  handle service reloads.
* Harden the firewall configuration, with a new zone for local-only services.

## Testing

We've got you covered. A complete end-to-end test of the setup process can be
achieved easily with Vagrant, just:

```
# Bring up all of the machines, installing and configuring Salt for later
# provisioning
$ UBIQUITOUS_NO_SHARE=1 vagrant up

# Fetch necessary binaries from the Internet; they're all checksummed on their
# way in :)
$ ./make-cache

# Provision the Salt master first, opening the ports necessary for
# master-minion configuration
$ vagrant ssh --command "sudo salt salt state.highstate"
$ vagrant reload salt

# Open up the necessary ports (as only SSH is available at this point):
$ vagrant/fix-firewalld-zones

# Then converge the rest of the machines
$ vagrant ssh --command "sudo salt '*' state.highstate"

# Finally, ensure any newly added services are allowed through FirewallD
$ vagrant/fix-firewalld-zones

# Create the data directories, apply security contexts
$ vagrant ssh app-debug-1 -c "sudo -u moodle mkdir ~moodle/data/{base,behat}"
$ vagrant ssh app-debug-1 -c "sudo restorecon -R ~moodle/htdocs/"
```

All of our guests use the official `centos/7` base box hosted on Atlas, and
they'll be configured with addresses consistent with the above network layout.

### Adding your own VMs

It's sometimes useful to be able to spin up additional machines with different
configurations, for instance when unit testing against multiple platforms. This
is possible within Vagrant environment by creating a `Vagrantfile.local` file in
the same directory as the `Vagrantfile`.

For instance, to add an additional Vagrant VM running SQL Server:

```ruby
config.vm.define "db-mssql-1" do |dbmssql1|
  dbmssql1.vm.box = "msabramo/mssqlserver2014express"

  dbmssql1.vm.network "private_network", ip: "192.168.120.160"
  dbmssql1.vm.hostname = "db-mssql-1.moodle"
end
```

### Behat

Ensure that all of the Behat-related options are present in your Moodle
`config.php`, then run the following command to bootstrap your test site:

```
$ vagrant ssh app-debug-1 --command 'sudo -u moodle php ~moodle/htdocs/admin/tool/behat/cli/init.php'
```

The acceptance test site will then be accessible from each of the application
servers at `/behat`. Run the tests with:

```
$ vagrant ssh app-debug-1 --command 'sudo -u moodle ~moodle/htdocs/vendor/bin/behat --config ~moodle/data/behat/behat/behat.yml --profile chrome --no-colors --out ../behat/_all_moodle_progress.txt --format moodle_progress --out ../behat/_all_pretty.txt --format pretty'
```

For the time being, the test harness itself has to be run against the web
server, as the data generator in the test harness requires access to the data
directory. This will change once we have a networked filesystem accessible to
both the machine running the test harness and the web server.

### PHPUnit

With the PHPUnit-related options present in your Moodle `config.php`, run
the following to enable PHPUnit:

```
$ vagrant ssh app-debug-1 --command "sudo -u moodle php ~moodle/htdocs/admin/tool/phpunit/cli/init.php"
```

### Xdebug

Servers with the `app-debug` role assigned will have Xdebug installed and
configured, allowing remote debugging.

## New server configuration

All servers in the cluster will be configured as Salt minions. Salt will handleexecute
configuring our servers based on roles which we'll define later. This section
assumes a stock, minimal installation of CentOS 7 with networking correctly
configured.

Start SSHd and instruct systemd to launch the service at boot time:

```
$ sudo systemctl start sshd
$ sudo systemctl enable sshd
```

Allow inbound SSH traffic through the firewall:

```
$ sudo firewall-cmd --permanent --zone=public --add-service=ssh
$ sudo firewall-cmd --reload
```

Add the SaltStack RPM repository:

```
$ sudo rpm --import https://repo.saltstack.com/yum/rhel7/SALTSTACK-GPG-KEY.pub
$ echo '[saltstack-repo]
name=SaltStack repo for RHEL/CentOS $releasever
baseurl=https://repo.saltstack.com/yum/rhel$releasever
enabled=1
gpgcheck=1
gpgkey=https://repo.saltstack.com/yum/rhel$releasever/SALTSTACK-GPG-KEY.pub' | sudo tee /etc/yum.repos.d/saltstack.repo
```

Configure the server as a Salt minion:

```
$ sudo yum install -y salt-minion
$ sudo sed -i "s/#master:.*/master: 192.168.120.5/" /etc/salt/minion
$ sudo sed -i "s/#id:.*/id: salt" /etc/salt/minion
```

The minion and master now need to exchange public keys to verify their
respective identities. Substitute the key below for the one you obtained from
your master during configuration. If you're currently configuring your master,
skip to the Salt master section of this document and return when you're done.

```
$ sudo sed -i "s/#master_finger:.*/master_finger: '3e:91:ad:e7:be:1f:63:16:c2:be:60:2b:7d:d5:f8:42'/" /etc/salt/minion
```

Start and enable the Salt minion daemon on boot:

```
$ sudo systemctl start salt-minion
$ sudo systemctl enable salt-minion
```

Now query its public key -- we need to verify this in the next step:

```
$ sudo salt-call --local key.finger
```

To complete the key exchange, log in to the Salt master and run the following
command to list all keys:

```
$ sudo salt-key -l all
```

In the "Unaccepted Keys" section, you should see the hostname of the server
you've been working on (in our case, `salt.moodle`). To verify its public key:

```
$ sudo salt-key -f salt.moodle
```

Assuming these two fingerprints are identical, we'll want to approve the key,
and hit `[Return]` when prompted to confirm:

```
$ sudo salt-key -a salt.moodle
```

To confirm everything's working correctly, we'll finish by sending the server
a `test.ping` operation:

```
$ sudo salt salt.moodle test.ping
```

### Application server

This role requires that the filesystem containing the Moodle installation has
support for Linux ACLs. If you're using `xfs`, which is the default filesystem
as of CentOS 7, ACLs are always enabled and you don't need to do anything. If
you're using `ext*`, you'll need to add the `acl` option to the corresponding
mountpoint in `/etc/fstab` and remount the volume.

### Salt master

Install the Salt master and some tools for managing our configuration:

```
$ sudo yum install git salt-master vim-enhanced
```

Configure the Salt master:

```
$ sudo sed -i "s/#interface:.*/interface: 192.168.120.5/" /etc/salt/master
```

Start the Salt master and launch it at boot time:

```
$ sudo systemctl start salt-master
$ sudo systemctl enable salt-master
```

Export the master's public key fingerprint, and store it for later. We'll need
this when adding Salt minions to facilitate secure key exchange.

```
$ sudo salt-key -F master | grep master.pub | cut -d' ' -f3-
```

Create the state tree based upon the contents of this repository and tighten its
permissions to prevent writes from unauthorised users:

```
$ sudo git clone https://github.com/LukeCarrier/moodle-ubiquitous.git /srv/salt
$ sudo chown -R admin:admin /srv/salt
$ find /srv/salt -type d -exec chmod 750 {} \;
$ find /srv/salt -type f -exec chmod 640 {} \;
```

# Using Ubiquitous in development

In development environments, Ubiquitous servers are created and managed in VirtualBox by Vagrant based on definitions in [the Vagrantfile](../../Vagrantfile). Once created, Vagrant's shell provisioner runs a script which installs the Salt master and minion daemons as appropriate for the role and seeds machines appropriate configuration and keys by [a script](../../vagrant/salt/install) as per configuration in. server configuration is managed by Salt, applying the states against [a default Salt pillar](../../vagrant/salt/pillar).

## Getting started

### Prerequisites

Install and be familiar with:

* [VirtualBox](https://www.virtualbox.org/) --- desktop virtualisation
* [Vagrant](https://www.vagrantup.com/) --- command line tool for managing virtualised development environments

Also be familiar with Salt - see [Salt Admin](../roles/salt)

Install some Vagrant plugins that'll make it easier to manage larger environments:

```
# Manage virtual machines in groups
$ vagrant plugin install vagrant-group

# Automatically manage Guest Additions versions
$ vagrant plugin install vagrant-vbguest
```
Start up all of the machines necessary for a testing environment:

```
$ cd moodle-ubiquitous
$ vagrant group up dev
```

The [Vagrantfile](/Vagrantfile) makes assumptions about the host environment, including:
 * Moodle itself is installed in `../Moodle` relative to Ubiquitous
 * standard ports are available (for e.g. SSH forwarding)

Use Vagrantfile.config and / or Vagrantfile.local to override as needed.

The first time you start the servers, and on changes to a Salt state definition, converge the machine state:

```
# Converge primary VM (Salt master) first
# This opens necessary ports for master-minion configuration
$ vagrant ssh --command 'sudo salt salt state.apply'

# Then converge the rest of the machines
$ vagrant ssh --command 'sudo salt '*' state.apply'
```
The above may take some time to complete; and can time out "Minion did not return. [No response]" while the minion is still configuring.
Re-try, or alternatively, perform manually for a specific minion:
$ vagrant ssh app-debug-1 --command 'sudo salt-call state.apply'

For the time being, the following commands are necessary to install the configuration for the Vagrant release and virtual host:

```
$ vagrant ssh --command 'sudo /usr/local/ubiquitous/bin/ubiquitous-set-current-release -d dev.local -r vagrant' app-debug-1
$ vagrant ssh --command 'mkdir data/base data/behat' app-debug-1
$ vagrant ssh --command 'sudo systemctl restart nginx' app-debug-1
$ vagrant ssh --command 'sudo systemctl restart php7.0-fpm' app-debug-1
```

The above may take some time to complete.

Afterwards, the following should become available:

* [Moodle](http://192.168.120.50/) --- your development environment
* [Behat instance](http://192.168.120.50/behat/) --- your development environment's Behat `wwwroot`
* [Behat fail dump](http://192.168.120.50/data/behat-faildump/) --- screenshots and page snapshots for failing Behat tests
* [MailCatcher](http://192.168.120.200:1080/) --- a simple mail server that allows you to browse all of the email it receives
* PostgreSQL --- `192.168.120.150:5432`

## Recommended Moodle configuration

Copy and paste [this config file](development-config.php) into ``../Moodle/config.php``; then, perform

```
# Sync your local sandbox to the Vagrant server
$ vagrant rsync app-debug-1
# Simulate a deployment
$ vagrant ssh app-debug-1 --command 'sudo /usr/local/ubiquitous/bin/ubiquitous-set-current-release -d dev.local -r vagrant'
# Verify
$ vagrant ssh app-debug-1 --command 'sudo less /home/ubuntu/current/config.php'
``` 
 
Visiting [your development environment](http://192.168.120.50) should then succeed.


## Running Moodle test suites

Moodle has three distinct environments for development (seperate from [Continuous Integration](docs/getting-started/test)):

* The development environment we interact with directly
* The Behat environment, which is a replica of the above with a different `wwwroot` and no content
* The PHPUnit environment, which is accessible only via the CLI

### Behat

Ubiquitous packages a Selenium Grid comprised of Chrome and Firefox nodes. To use it, first bring up the Selenium grid:

```
# Start the servers
$ vagrant group up selenium

# If it's your first time, let Salt configure them
$ vagrant ssh salt --command 'sudo salt 'selenium-*' state.apply'
```

Once complete, the following services will be available to you:

* [Selenium Grid console](http://192.168.120.100:4444/grid/console) --- see an overview of available nodes, helpful for diagnosing registration issues
* VNC for the Selenium Chrome node --- `192.168.120.105:5999`
* VNC for the Selenium Firefox node --- `192.168.120.110:5999`

### Behat

Review the Behat-related options in your Moodle `config.php` (see the recommended configuration for advice) and run the following command to bootstrap the testing environment:

```
$ vagrant ssh app-debug-1 --command 'php ~/releases/vagrant/admin/tool/behat/cli/init.php'
```

The acceptance test site will then be accessible from each of the application servers at `{wwwroot}/behat`.

Some of the tests attempt to upload files within the Moodle source tree to the application. We must therefore synchronise the Moodle source tree to the Selenium nodes and apply [a patch](https://github.com/moodle/moodle/compare/master...LukeCarrier:MDL-NOBUG-selenium-remote-node-file-upload-master) to Moodle to allow it to locate these files:

```
$ vagrant rsync selenium-node-chrome
$ vagrant rsync selenium-node-firefox
```

Run the tests with e.g.:

```
$ vagrant ssh app-debug-1 --command 'current/vendor/bin/behat --config data/behat/behatrun/behat/behat.yml --profile chrome'
```

### PHPUnit

Review the PHPUnit-related options in your Moodle `config.php` (see the recommended configuration for advice) and run the following command to bootstrap the testing environment:

```
$ vagrant ssh app-debug-1 --command 'php ~/releases/vagrant/admin/tool/phpunit/cli/init.php'
```

Run the tests with e.g.:

```
$ vagrant ssh app-debug-1 --command '~/releases/vagrant/vendor/bin/phpunit -c ~/releases/vagrant/ --group=core_group'
```

## Advanced topics

### Adding your own virtual machines

It's sometimes useful to be able to spin up additional machines with different configurations, for instance when unit testing against multiple platforms. This is possible within Vagrant environment by creating a `Vagrantfile.local` file in the same directory as the `Vagrantfile`.

For instance, to add an additional Vagrant VM running SQL Server:

```ruby
config.vm.define "db-mssql-1" do |dbmssql1|
  dbmssql1.vm.box = "msabramo/mssqlserver2014express"

  dbmssql1.vm.network "private_network", ip: "192.168.120.160"
  dbmssql1.vm.hostname = "db-mssql-1.moodle"
end
```

### Network configuration

The default network configuration of the Vagrant configuration is below. Note that not all of the machines listed will be started for most configurations.

| IP address | Hostname | Server role |
| --- | --- | --- |
| `192.168.120.5` | `salt.moodle` | Salt master |
| `192.168.120.10` | `gocd.moodle` | GoCD server |
| `192.168.120.15` | `named.moodle` | BIND named server |
| `192.168.120.50` | `app-debug-1.moodle` | Application server (with debugging) |
| `192.168.120.100` | `selenium-hub.moodle` | Selenium grid hub |
| `192.168.120.105` | `selenium-node-chrome.moodle` | Selenium node (Chrome) |
| `192.168.120.110` | `selenium-node-firefox.moodle` | Selenium node (Firefox) |
| `192.168.120.150` | `db-pgsql-1.moodle` | PostgreSQL server |
| `192.168.120.200` | `mail-debug.moodle` | Mail catcher |

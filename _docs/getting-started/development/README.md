# Preparing a development environment

Before getting a development environment configured you'll need to install some external dependencies.

Note that guides within this document are provided on a best-effort basis. If you're struggling to get started, please open [an issue](https://github.com/AVADOLearning/moodle-ubiquitous/issues).

## The general idea

First, prepare your development by installing the following applications:

* [VirtualBox](https://www.virtualbox.org/) --- desktop virtualisation
* [Vagrant](https://www.vagrantup.com/) --- command line tool for managing virtualised development environments.

Then install some Vagrant plugins that'll make it easier to manage larger environments:

```
# Manage virtual machines in groups
$ vagrant plugin install vagrant-group

# Automatically manage Guest Additions versions
$ vagrant plugin install vagrant-vbguest
```

## Linux

1. Install [VirtualBox](https://www.virtualbox.org/). We recommend using the Oracle-supplied packages rather than those provided by your distribution.
2. Install [Vagrant](https://www.vagrantup.com/), using the appropriate package for your distribution and system architecture.
3. Install the [`vagrant-group`](https://github.com/vagrant-group/vagrant-group) and [`vagrant-vbguest`](https://github.com/dotless-de/vagrant-vbguest) Vagrant plugins.

## macOS

1. Install [VirtualBox](https://www.virtualbox.org/). If the installation fails to complete [because a kernel extension wasn't trusted](https://developer.apple.com/library/content/technotes/tn2459/_index.html), approve the installation and re-run the installation package. It should complete successfully the second time.
2. Install [Vagrant](https://www.vagrantup.com/).
3. Install the [`vagrant-group`](https://github.com/vagrant-group/vagrant-group) and [`vagrant-vbguest`](https://github.com/dotless-de/vagrant-vbguest) Vagrant plugins.

## Windows

1. Install [VirtualBox](https://www.virtualbox.org/).
2. Install [Vagrant](https://www.vagrantup.com/).
3. Install the [`vagrant-group`](https://github.com/vagrant-group/vagrant-group) and [`vagrant-vbguest`](https://github.com/dotless-de/vagrant-vbguest) Vagrant plugins.

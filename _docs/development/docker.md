# Docker

This document will cover the internals of the containers from the perspective of a maintainer. For overview information, see the page on [getting started in test environments](../getting-started/test.md).

Per-service containers are a work in progress.

## Preparing a build environment

Ensure the `docker` Python module (formerly `docker-py`) is installed:

```
$ sudo apt install python-pip
$ sudo salt-call --local pip.uninstall docker-py
$ sudo salt-call --local pip.install docker
```

Test that the execution module is ready to go:

```
$ sudo salt-call -l debug --local sys.argspec 'docker.*'
```

## Build the base container

Since the Salt `docker` module expects a Python installation to be present on the container, build our base container:

```
$ docker build _docker/ubuntu-python -t ubiquitous/ubuntu-python:16.04
```

## Build an individual service container

Containers are broken out into a number of separate per-service containers. To build, invoke the `build` script with the appropriate arguments. For example:

```
$ sudo _docker/service/build \
        -c ubiquitous/moodle-build -m moodle-componentmgr -m admin -m nvm
```

Internally, this invokes the `docker.sls_build` function with a series of arguments:

```
$ sudo salt-call \
        -l debug --local \
        --file-root "$PWD" \
        --pillar-root "${PWD}/_docker/service/salt/pillar" \
        docker.sls_build ubiquitous/moodle-build \
        base=ubiquitous/ubuntu-python:16.04 mods=moodle-componentmgr,admin,nvm
```

Note: at the present time Python versions on the host and container must match in order for this to work, as the "thin" installation Salt ships to the containers are derived from the running Salt installation.

## Building all service containers

A utility is provided for building all service containers together:

```
$ sudo _docker/service/init
```

## Automating container builds

To ensure that your container image is always up to date we recommend using [Travis](https://travis-ci.org/) to run builds triggered using webhooks. Use of Docker Hub isn't possible as our per-service containers require Salt to be installed on the build server, but Hub doesn't allow us to access the build machine to install it.

To configure this, create a Travis project and configure credentials for the Docker CLI so you're able to push builds to Docker Hub. We can do this with the [Travis CLI](https://github.com/travis-ci/travis.rb):

```
$ travis enable

$ travis env set DOCKER_USERNAME exampleusername
$ travis env set DOCKER_PASSWORD examplepassword
```

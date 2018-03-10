# Docker

This document will cover the internals of the containers from the perspective of a maintainer. For overview information, see the page on [getting started in test environments](../getting-started/test.md).

## All-in-one container

The all-in-one Docker container image can be built from the [Dockerfile](../../Dockerfile) with a single command:

```
$ docker build -f _docker/allinone/Dockerfile -t ubiquitous/allinone .
```

## Per-service containers

Per-service containers are a work in progress.

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

Since the Salt `docker` module expects a Python installation to be present on the container, build our base container:

```
$ docker build _docker/ubuntu-python -t ubiquitous/ubuntu-python:16.04
```

Then, to build:

```
sudo salt-call -l debug --local docker.sls_build ubiquitous/<name> base=ubiquitous/ubuntu-python:16.04 mods=<roles>
```

## Automating container builds

To ensure that your container image is always up to date we recommend using [Travis](https://travis-ci.org/) to run builds triggered using webhooks. Use of Docker Hub isn't possible for either type of container image:

* Our all-in-one container image, built using a straightforward Dockerfile, can't be built as it's not possible to specify the `--file` argument to `docker build`. Setting the _Dockerfile location_ field changes the context directory, preventing us from accessing our Salt state and pillar trees.
* Our per-service containers require Salt to be installed on the build server, but Hub doesn't allow us to access it.

To configure this, create a Travis project and configure credentials for the Docker CLI so you're able to push builds to Docker Hub. We can do this with the [Travis CLI](https://github.com/travis-ci/travis.rb):

```
$ travis enable

$ travis env set DOCKER_USERNAME exampleusername
$ travis env set DOCKER_PASSWORD examplepassword
```

# Using Ubiquitous in test environments

The testing configuration is designed for use in continuous integration platforms built around containers. Services can either be installed to and run from a single container or be broken out into multiple containers. At test time, the hosting service will either mount a volume or copy the files into the container, then run a series of shell commands which will start the services and run the tests.

## Obtaining containers

[Pre-built containers](https://hub.docker.com/u/ubiquitous/) are made available on Docker Hub. Since these containers may change on a whim, potentially interfering with your test results, you're advised to follow the instructions below to build your own.

Details on building the containers can be found in the [developer documentation](../development/docker.md).

## Per-service containers

Per-service containers are a work in progress.

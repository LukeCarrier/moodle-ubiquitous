# Using Ubiquitous in test environments

The testing configuration is designed for use in continuous integration platforms built around containers. In this setup, all services are installed to a single container. At test time, the hosting service will either mount a volume or copy the files into the container, then run a series of shell commands which will start the services and run the tests.

## Building the container

The recommended approach for building the container image is to allow the Docker Hub to run the build against your Git repository using webhooks, ensuring that your container image is always up to date. See [the Docker Hub automated builds](https://docs.docker.com/docker-hub/builds/), Docker Hub will perform automated builds of the container image from the repository.

The Docker container image can be built from the [Dockerfile](../../Dockerfile) with a single command:

```
$ docker build .
```

## Key differences

The Docker configuration differs from other configurations in a number of ways due to design constraints of tools it's designed to operate within.

### All roles bundled together

Docker images contain the following role loadout:

* app
* app-debug
* db-pgsql
* selenium-hub
* selenium-node-chrome

As more CI services adopt [Docker Compose](https://docs.docker.com/compose/) or similar to support multiple containers, we will revisit this decision.

### Filesystem ACLs

Ubiquitous ordinarily requires that application server `/home` filesystems support extended attributes and, in turn, ACLs. Since none of Docker's many filesystems support ACLs, we instead run all services under the user account which owns the platform files.

### iptables

Since containers do not maintain their own kernels, there is no notion of an iptables-based firewall within them. iptables rules are not applied to Docker containers; we instead use [`EXPOSE` directives in the Dockerfile](https://docs.docker.com/engine/reference/builder/#expose).

### systemd

Docker is designed to contain individual processes within each container. In lieu of an init system running in each container, you're encouraged to manage multiple containers using [Docker Compose](https://docs.docker.com/compose/). Unfortunately this is not how CI platforms such as [GitLab CI](https://about.gitlab.com/gitlab-ci/) and [Bitbucket Pipelines](https://bitbucket.org/product/features/pipelines) are using containers.

It's impractical to enable and use it within containers, requiring either very specific volume configurations or executing the container in `--privileged` mode. Since both options are unreasonable from a security standpoint, we have worked around this by providing our own launch script to manage the services.

## Recommended CI configurations

These configurations should form a good base for your own environment.

### BitBucket Pipelines

```yaml
image: lukecarrier/moodle-ubiquitous

pipelines:
  default:
    - step:
        script:
          - pwd
          - env
          - locale-gen en_AU.UTF-8
          - update-locale
          - /usr/local/ubiquitous/bin/ubiquitous-ctl start
          - cp -r * ~ubuntu/releases/test
          - chown -R ubuntu:ubuntu ~ubuntu/releases/test
          - cd ~ubuntu/current/
          - sudo -u ubuntu cp config-dist.php config.php
          - sudo -u ubuntu sed -i -e "s%= 'moodle'%= 'ubuntu'%" config.php
          - sudo -u ubuntu sed -i -e "s%= 'username'%= 'ubuntu'%" config.php
          - sudo -u ubuntu sed -i -e "s%= 'password'%= 'gibberish'%" config.php
          - sudo -u ubuntu sed -i -e "s%http://example.com/moodle%http://localhost%" -e "s%/home/example/moodledata%/home/ubuntu/data/base%" config.php
          - sudo -u ubuntu mkdir -p ~ubuntu/data/base ~ubuntu/data/phpunit
          - sudo -u ubuntu sed -i -e "/require_once/i \\\$CFG->phpunit_dataroot = '\/home\/ubuntu\/data\/phpunit';" -e "/require_once/i \\\$CFG->phpunit_prefix = 'p_';" config.php
          - sudo -u ubuntu php admin/cli/install_database.php --agree-license --adminpass='P4$$word'
          - sudo -u ubuntu php admin/tool/phpunit/cli/init.php
          - sudo -u ubuntu vendor/bin/phpunit
```

# Using Ubiquitous in test environments

The testing configuration is designed for use in continuous integration platforms built around containers. Services can either be installed to and run from a single container or be broken out into multiple containers. At test time, the hosting service will either mount a volume or copy the files into the container, then run a series of shell commands which will start the services and run the tests.

## Obtaining containers

[Pre-built containers](https://hub.docker.com/u/ubiquitous/) are made available on Docker Hub. Since these containers may change on a whim, potentially interfering with your test results, you're advised to follow the instructions below to build your own.

Details on building the containers can be found in the [developer documentation](../development/docker.md).

## All-in-one container

This container rolls all of the services into a single container and is comprised of the following roles:

* `app` and `app-debug` provide an application server ready for remote debugging and code coverage analysis.
* `db-pgsql` allows hosting a PostgreSQL database.
* `selenium-hub` and `selenium-node-chrome` run acceptance tests for Behat.

## Per-service containers

Per-service containers are a work in progress.

## Usage

The test scripts support two modes of operation:

* Testing entire platforms, where a complete Moodle installation is supplied as the source.
* Testing individual components, where a Moodle site is packaged around the component using [Component Manager](https://github.com/lukecarrier/moodle-componentmgr).

### Entire platforms

Launch the container with the `/app` volume pointed at a complete Moodle installation:

```
$ docker run -it \
        --volume "$(dirname $PWD)/Moodle":/app \
        --workdir /app --memory 4g --memory-swap 4g \
        --publish 8080:80 --publish 8044:4444 \
        --publish 8055:5555 --publish 8056:5556 --publish 8057:5557 --publish 8058:5558 \
        --publish 8065:5995 --publish 8066:5996 --publish 8067:5997 --publish 8068:5998 \
        --entrypoint /bin/bash ubiquitous/allinone
```

Within the container:

```
$ /usr/local/ubiquitous/bin/ubiquitous-ctl start
$ /usr/local/ubiquitous/bin/ubiquitous-prepare-platform --source-directory /app
$ /usr/local/ubiquitous/bin/ubiquitous-prepare
$ /usr/local/ubiquitous/bin/ubiquitous-run-tests
```

### Individual components

Launch the container with the `/app` volume pointed at a single Moodle component:

```
$ docker run -it \
        --volume "$(dirname $PWD)/Moodle/blocks/helloworld":/app \
        --workdir /app --memory 4g --memory-swap 4g \
        --publish 8080:80 --publish 8044:4444 \
        --publish 8055:5555 --publish 8056:5556 --publish 8057:5557 --publish 8058:5558 \
        --publish 8065:5995 --publish 8066:5996 --publish 8067:5997 --publish 8068:5998 \
        --entrypoint /bin/bash ubiquitous/allinone
```

Within the container:

```
$ /usr/local/ubiquitous/bin/ubiquitous-ctl start
$ /usr/local/ubiquitous/bin/ubiquitous-prepare-component \
        --source-directory /app \
        --project-file tests/integration/componentmgr.json
$ /usr/local/ubiquitous/bin/ubiquitous-prepare
$ /usr/local/ubiquitous/bin/ubiquitous-run-tests
```

#### SSH authentication

If your build process requires you to fetch additional components or other dependencies, insert a key:

```
$ mkdir ~/.ssh
$ chmod 0700 ~/.ssh       
$ vim ~/.ssh/id_rsa
$ chmod 0600 ~/.ssh/id_rsa
```

## Testing the containers

First, prepare an alternative Moodle directory you can mount as a volume on your container. Reusing an existing directory is not recommended as you will need a different configuration file. Git worktrees may be useful for this:

```
$ cd Moodle/
$ git worktree add ../MoodleDocker
```

Then start the container:

```
$ cd Ubiquitous/
$ docker run -it \
        --volume "$(dirname $PWD)/MoodleDocker":/home/vagrant/releases/test \
        --workdir /home/vagrant/releases/test --memory 4g --memory-swap 4g \
        --publish 8080:80 --publish 8044:4444 \
        --publish 8055:5555 --publish 8056:5556 --publish 8057:5557 --publish 8058:5558 \
        --publish 8065:5995 --publish 8066:5996 --publish 8067:5997 --publish 8068:5998 \
        --entrypoint /bin/bash ubiquitous/allinone
```

Note the `--publish` arguments here, which make the following services accessible once started inside the container:

* [The Moodle site](http://localhost:8080/)
* [Selenium Hub](http://localhost:8044/)
* Selenium Nodes [1](http://localhost:8055/), [2](http://localhost:8056/), [3](http://localhost:8057/) and [4](http://localhost:8058/)
* VNC on Selenium nodes:
    * 1 --- `localhost:8065`
    * 2 --- `localhost:8066`
    * 3 --- `localhost:8067`
    * 4 --- `localhost:8068`

To keep an eye on the test runs, a VNC viewer capable of displaying thumbnails of multiple servers (such as [VNC Thumbnail Viewer](https://thetechnologyteacher.wordpress.com/vncthumbnailviewer/) may be useful:

```
$ java -classpath VncThumbnailViewer.jar VncThumbnailViewer \
        HOST localhost PORT 8065 \
        HOST localhost PORT 8066 \
        HOST localhost PORT 8067 \
        HOST localhost PORT 8068
```

Since systemd is unavailable within the container, services can be started with a control script:

```
$ /usr/local/ubiquitous/bin/ubiquitous-ctl start
```

We then need to copy the Moodle source files from the working directory in which we started the container, install the configuration file generated by the Salt states, ensure the permissions on these files are correct and install the base, PHPUnit and Behat sites:

```
$ /usr/local/ubiquitous/bin/ubiquitous-prepare-full
```

We can now run the suites:

```
$ /usr/local/ubiquitous/bin/ubiquitous-run-tests
```

## Key differences

The Docker configuration differs from other configurations in a number of ways due to design constraints of tools it's designed to operate within.

### Filesystem ACLs

Ubiquitous ordinarily requires that application server `/home` filesystems support extended attributes and, in turn, ACLs. Since none of Docker's many filesystems support ACLs, we instead run all services under the user account that owns the platform files.

### systemd

Docker is designed to contain individual processes within each container. In lieu of an init system running in each container, you're encouraged to manage multiple containers using [Docker Compose](https://docs.docker.com/compose/). Unfortunately this is not how CI platforms such as [GitLab CI](https://about.gitlab.com/gitlab-ci/) and [Bitbucket Pipelines](https://bitbucket.org/product/features/pipelines) are using containers.

It's impractical to enable and use it within containers, requiring either very specific volume configurations or executing the container in `--privileged` mode. Since both options are unreasonable from a security standpoint, we have worked around this by providing our own launch script to manage the services.

## Recommended CI configurations

These configurations should form a good base for your own environment.

### BitBucket Pipelines

For entire platforms:

```yaml
image: ubiquitous/allinone

pipelines:
  default:
    - step:
        script:
          - /usr/local/ubiquitous/bin/ubiquitous-ctl start
          - /usr/local/ubiquitous/bin/ubiquitous-prepare-platform
          - /usr/local/ubiquitous/bin/ubiquitous-prepare
          - /usr/local/ubiquitous/bin/ubiquitous-run-tests
```

For individual components:

```yaml
image: ubiquitous/allinone

pipelines:
  default:
    - step:
        script:
          - /usr/local/ubiquitous/bin/ubiquitous-ctl start
          - /usr/local/ubiquitous/bin/ubiquitous-prepare-component
          - /usr/local/ubiquitous/bin/ubiquitous-prepare
          - /usr/local/ubiquitous/bin/ubiquitous-run-tests
```

## Troubleshooting

Note that more in-depth documentation around the Selenium configuration can be found on [the Selenium role page](../roles/selenium.md). The documentationm below is specific to the Docker container.

### Watching tests over VNC

A VNC server is shipped with the container but is not started by default. To launch it:

```
$ /usr/local/ubiquitous/bin/ubiquitous-ctl start x11vnc
```

### Remoting in with SSH

As the base role is implicitly applied to the container, an OpenSSH server is installed and available for use. If you're unable to effectively troubleshoot over a single session, it can be started as follows:

```
$ mkdir /var/run/sshd
$ sshd
```

# Developing Salt

These instructions are derived from [Salt's "installing Salt for development"](https://docs.saltstack.com/en/latest/topics/development/hacking.html) documentation.

## Getting started

Ensure that [Python](https://www.python.org/) (version 3 is preferred), [pip](https://pip.pypa.io/) (available as part of the standard distribution with Python >= 2.7.9 and >= 3.4) and [virtualenv](https://virtualenv.pypa.io/) are installed on your development machine. This allows us create isolated Python environments.

```
$ pip3 install virtualenv
```

Clone a copy of Salt:

```
$ git clone git@github.com:saltstack/salt.git Salt
```

Now create an isolated development environment inside of the cloned copy of Salt and install Salt into that environment. Note the use of the `-e` switch to install Salt in editable mode:

```
$ cd Salt/
$ virtualenv -p python3 .
$ . bin/activate
$ pip3 install -e .
$ pip3 install \
        -r requirements/base.txt \
        -r requirements/zeromq.txt \
        -r requirements/dev_python34.txt
$ deactivate
```

Whenever working with this virtual environment in the future, you'll need to do the following to enable it:

```
$ . bin/activate
```

And this to disable it:

```
$ deactivate
```

## One-time configuration

Copy the default configuration from the `conf` directory to `etc/salt` in your working copy:

```
$ mkdir etc
$ cp -r conf/ etc/salt
```

Edit the following options in `etc/salt/master` and `etc/salt/minion`:

* `user` --- your username (`echo $USER`)
* `root_dir` --- the full path to your working copy of Salt
* `pki_dir` --- the full path to your working copy of Salt followed by `/etc/salt/pki`

### Masterless

To run the Salt minion in masterless mode (useful for debugging), set `file_client` to `local` in `etc/salt/minion`.

## Starting Salt

Note that Salt's daemons all accept a `-d` switch which allows them to fork (daemonise) and run in the background. When running in this state they will log to

Both the daemons and command line tools accept the `-l` switch, which allows setting the log level.

To start the master:

```
$ salt-master -c etc/salt
```

## Unit tests

Ubiquitous ships with Salt execution and state modules to provide functionality not included with the base Salt distribution.

Since it's not currently possible to test these modules outside of the scope of a Salt development environment we have to copy our modules and tests into a Salt tree and run the tests from there.

To prepare an environment for the first time:

```
$ deactivate
```

To run all of the tests:

```
$ cd Ubiquitous/
$ _tests/run-tests -s Salt
```

Once complete, deactivate the `virtualenv`:

```
$ deactivate
```

# Tests

## Unit tests

Ubiquitous ships with Salt execution and state modules to provide functionality not included with the base Salt distribution.

Since it's not currently possible to test these modules outside of the scope of a Salt development environment we have to copy our modules and tests into a Salt tree and run the tests from there.

To prepare an environment for the first time:

```
$ pip3 install virtualenv
$ git clone git@github.com:saltstack/salt.git Salt
$ cd Salt/
$ virtualenv -p python3 .
$ . bin/activate
$ pip3 install \
        -r requirements/base.txt \
        -r requirements/zeromq.txt \
        -r requirements/dev_python34.txt
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

# Debugging

The `app-debug` role is intended for use in development and integration environments. It serves two purposes:

1. Makes available the Xdebug extension for PHP debugging and profiling, including raising web server timeouts to accommodate debugging sessions.
2. Provides an alias for the Moodle installation at `/behat`, required for the [acceptance testing environment](https://docs.moodle.org/dev/Running_acceptance_test), and access to the fail dump for troubleshooting.

## Xdebug

Xdebug is configured for on-demand [debugging](https://xdebug.org/docs/remote) and [profiling](https://xdebug.org/docs/profiler). Sessions can be started from a web browser using the following browser extensions:

* [Xdebug Helper](https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc?hl=en) for Chrome.
* [The Easiest Xdebug](https://addons.mozilla.org/en-US/firefox/addon/the-easiest-xdebug/) for Firefox.

### Debugging

Remote debugging allows PHP processes to connect to your IDE, allowing you to step through code and explore program state. Before starting debugging sessions you must configure your IDE to accept them.

#### PhpStorm

Add a remote server and configure a path mapping for the application's root directory, allowing PhpStorm to associate local working copies of files with those on the server. Replace the values below as appropriate for your environment.

1. Open the settings window (_File_ -> _Settings_).
2. Navigate to _Languages & Frameworks_ -> _PHP_ -> _Servers_.
3. Click _+_.
4. Set the following fields:
    * _Name_ to `app-debug-1`.
    * _Host_ to `192.168.120.50`.
5. Enable _Use path mappings_.
6. Locate the root directory of the application and fill in the _Absolute path on the server_ field to `/home/ubuntu/releases/vagrant`.

Since Moodle serves many assets via PHP, you'll probably want to disable the _Notify if debug session was finished without being paused_ option (_Languages & Frameworks_ -> _PHP_ -> _Debug_, under _Advanced settings_). This will silence the warnings when no breakpoint pauses handling of these requests.

### Profiling

Xdebug profiler output is written to `{home}/data/profiling` for each platform when enabled. These Callgrind format files can be opened with a tool such as [KCachegrind](https://kcachegrind.github.io/).

## Behat

Ensure the necessary `$CFG->behat_*` configuration options are included in your Moodle `config.php` as per [the recommended configuration](../../getting-started/development.md#recommended-moodle-configuration).

From your application server install Behat and its dependencies and generate a configuration file:

```
$ cd current/
$ php admin/tool/behat/cli/init.php
```

When modifying Behat step definitions or adding new feature files you'll need to rebuild the `behat.yml` configuration file for the changes to take effect:

```
$ php admin/tool/behat/cli/util.php --enable
```

The recommended means of running tests is via `admin/tool/behat/cli/run.php`, which wraps the `behat` command and will coordinate [parallel test runs across multiple concurrent Selenium sessions](https://docs.moodle.org/dev/Running_acceptance_test#Parallel_runs_2):

```
# Single run (recommended for development; especially if you're watching the
# run over VNC).
$ php admin/tool/behat/cli/run.php --tags=core_course

# Parallel run across four sessions (recommended in integration environments;
# the default number of Selenium nodes provisioned per host in the Docker and
# Vagrant pillars).
$ php admin/tool/behat/cli/run.php --parallel=4 --tags=core_course
```

Note that `run.php` does not correctly handle arguments in the form `--parallel 4`. _Always_ use equals signs between argument names and values.

The Behat faildump for each platform can be accessed from a browser at `{document root}/data/behat-faildump`.

For further usage information, please refer to the following resources:

* [Running acceptance tests](https://docs.moodle.org/dev/Running_acceptance_test) --- provides a high level overview of the Moodle Behat configuration, testing tools and conventions.
* [Working version matrix](https://docs.moodle.org/dev/Acceptance_testing/Browsers/Working_combinations_of_OS%2BBrowser%2Bselenium) --- a summary of "known good" Selenium, driver and browser versions. This may be useful when troubleshooting arcane test failures or Selenium crashes.

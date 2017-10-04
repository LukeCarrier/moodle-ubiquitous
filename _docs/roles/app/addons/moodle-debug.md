# Debugging Moodle

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

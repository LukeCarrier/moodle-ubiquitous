# Debugging

The `app-debug` role is intended for use in development and integration environments. It installs and configures the Xdebug extension for PHP debugging and profiling, including raising web server timeouts to accommodate debugging sessions.


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

Xdebug profiler output is written to `{home}/data/profiling` for each platform when enabled. For easier access this directory is also made accessible over HTTP at `/data/profiling`. These Callgrind format files can be opened with a tool such as [KCachegrind](https://kcachegrind.github.io/).

# Using Ubiquitous for Moodle development

You'll need to structure your Moodle development environment appropriately. Ubiquitous sets up a synced folder for `../Moodle` relative to itself to get your source code to the application server:

```
.
├── Moodle
└── Ubiquitous
```

Start up all of the machines necessary for a development environment:

```
$ vagrant up salt
$ vagrant group up moodle
```

The first time you start the servers, and whenever you make changes to the Salt states, you'll need to apply the states to the machines:

```
# Provision the Salt master first, opening the ports necessary for
# master-minion configuration
$ vagrant ssh --command 'sudo salt-call state.apply'

# Then converge the rest of the machines
$ vagrant group ssh --command "sudo salt-call state.apply"
```

The above may take some time to complete. Once the above commands complete, the following services should now be available to you:

* [Moodle](http://192.168.120.50/) --- your development environment
* [Behat instance](http://192.168.120.50/behat/) --- your development environment's Behat `wwwroot`
* [Behat fail dump](http://192.168.120.50/data/behat-faildump/) --- screenshots and page snapshots for failing Behat tests
* [MailCatcher](http://192.168.120.200:1080/) --- a simple mail server that allows you to browse all of the email it receives
* PostgreSQL database at `192.168.120.150:5432` --- use an [open source tool](https://wiki.postgresql.org/wiki/Community_Guide_to_PostgreSQL_GUI_Tools#Open_Source_.2F_Free_Software) to connect to it.

## Recommended Moodle configuration

The following configuration ensures that complex parts of Ubiquitous such as the Behat testing environment function as expected.

```php
<?php // Moodle configuration file

// Boilerplate
unset($CFG);
global $CFG;
$CFG = new stdClass();

// Database server
    // MySQL
    //$CFG->dbtype    = 'mysqli';
    //$CFG->dblibrary = 'native';
    //$CFG->dbhost    = '192.168.120.155';
    //$CFG->dbname    = 'moodle';
    //$CFG->dbuser    = 'moodle';
    //$CFG->dbpass    = 'Password123';
    //$CFG->prefix    = 'mdl_';
    //$CFG->dboptions = array (
    //    'dbpersist' => 0,
    //    'dbport'    => 3306,
    //    'dbsocket'  => '',
    //);

    // PostgreSQL
    $CFG->dbtype    = 'pgsql';
    $CFG->dblibrary = 'native';
    $CFG->dbhost    = '192.168.120.150';
    $CFG->dbname    = 'ubuntu';
    $CFG->dbuser    = 'ubuntu';
    $CFG->dbpass    = 'gibberish';
    $CFG->prefix    = 'mdl_';
    $CFG->dboptions = array (
        'dbpersist' => 0,
        'dbport'    => 5432,
        'dbsocket'  => '',
    );

    // SQL Server
    //$CFG->dbtype    = 'sqlsrv';
    //$CFG->dblibrary = 'native';
    //$CFG->dbhost    = 'tcp:192.168.120.155';
    //$CFG->dbname    = 'moodle';
    //$CFG->dbuser    = 'moodle';
    //$CFG->dbpass    = 'Password123';
    //$CFG->prefix    = 'mdl_';
    //$CFG->dboptions = array(
    //    'dbpersist' => 0,
    //    'dbport'    => 1433,
    //    'dbsocket'  => '',
    //);

// Base URLs
$CFG->wwwroot = 'http://192.168.120.50';
$CFG->admin   = 'admin';

// Data directory
$CFG->dataroot             = '/home/ubuntu/data/base';
$CFG->directorypermissions = 0770;

// Send mails via MailCatcher on mail-debug
$CFG->smtphosts = '192.168.120.200:1025';

// Enable debugging
$CFG->debug        = E_ALL;
$CFG->debugdisplay = true;

// Common developer options
//$CFG->debugstringids = true;
//$CFG->langstringcache = false;
//$CFG->cachejs = false;
//$CFG->themedesignermode = true;

// Behat testing environment
$CFG->behat_prefix        = 'b_';
$CFG->behat_dataroot      = '/home/ubuntu/data/behat';
$CFG->behat_faildump_path = '/home/ubuntu/data/behat-faildump';
$CFG->behat_wwwroot       = 'http://192.168.120.50/behat';
$CFG->behat_profiles = array(
'chrome' => array(
    'extensions' => array(
        'Behat\MinkExtension' => array(
            'selenium2' => array(
                'browser' => 'chrome',
                'capabilities' => array(
                    'browser' => 'chrome',
                    'browserName' => 'chrome',
                ),
            ),
        ),
    ),
),
'firefox' => array(
    'extensions' => array(
        'Behat\MinkExtension' => array(
            'selenium2' => array(
                'browser' => 'firefox',
                'capabilities' => array(
                    'browser' => 'firefox',
                    'browserName' => 'firefox',
                ),
            ),
        ),
    ),
),
'iexplore' => array(
    'extensions' => array(
        'Behat\MinkExtension' => array(
            'selenium2' => array(
                'browser' => 'iexplore',
                'capabilities' => array(
                    'browser' => 'iexplore',
                    'browserName' => 'iexplore',
                ),
            ),
        ),
    ),
),
);
$CFG->behat_config = array_merge(array(
'default' => array(
    'extensions' => array(
        'Behat\MinkExtension' => array(
            'selenium2' => array(
                'wd_host' => 'http://192.168.120.100:4444/wd/hub',
                'capabilities' => array(
                    'browserVersion'    => 'ANY',
                    'deviceType'        => 'ANY',
                    'name'              => 'ANY',
                    'deviceOrientation' => 'ANY',
                    'ignoreZoomSetting' => 'ANY',
                    'version'           => 'ANY',
                    'platform'          => 'ANY',
                ),
            ),
        ),
    ),
),
), $CFG->behat_profiles);

// Selenium node path configuration
// Requires https://github.com/moodle/moodle/compare/master...LukeCarrier:MDL-NOBUG-selenium-remote-node-file-upload-master
$CFG->behat_node_dirroot = '/var/lib/selenium/moodle';
$CFG->behat_node_dir_sep = '/';

// PHPUnit testing environment
$CFG->phpunit_prefix   = 'phpu_';
$CFG->phpunit_dataroot = dirname($CFG->dataroot) . '/phpunit';

// Bootstrap Moodle
require_once __DIR__ . '/lib/setup.php';
```

## Running Moodle test suites

Moodle has three distinct environments for development:

* The development environment we interact with directly
* The Behat environment, which is a replica of the above with a different `wwwroot` and no content
* The PHPUnit environment, which is accessible only via the CLI.

### Behat

Ubiquitous packages a Selenium Grid comprised of Chrome and Firefox nodes. To use it, first bring up the Selenium grid:

```
# Start the servers
$ vagrant group up selenium

# If it's your first time, let Salt configure them
$ vagrant group ssh selenium --command "sudo salt-call state.apply"
```

Once complete, the following services will be available to you:

* [Selenium Grid console](http://192.168.120.100:4444/grid/console) --- see an overview of available nodes, helpful for diagnosing registration issues
* VNC for the Selenium Chrome node at `192.168.120.105:5555` through `:5558` --- use an [open-source tool](https://en.wikipedia.org/wiki/Comparison_of_remote_desktop_software) to connect to it
* VNC for the Selenium Firefox node at `192.168.120.110:5555` through `:5558`.

Then ensure that all of the Behat-related options are present in your Moodle `config.php` (see the recommended configuration for advice) and run the following command to bootstrap your test site:

```
$ vagrant ssh app-debug-1 --command 'php current/admin/tool/behat/cli/init.php'
```

The acceptance test site will then be accessible from each of the application servers at [`{wwwroot}/behat`](http://192.168.120.50/behat/).

Some of the tests attempt to upload files within the Moodle source tree to the application. We must therefore synchronise the Moodle source tree to the Selenium nodes and apply [a patch](https://github.com/moodle/moodle/compare/master...LukeCarrier:MDL-NOBUG-selenium-remote-node-file-upload-master) to Moodle to allow it to locate these files:

```
$ vagrant rsync selenium-node-chrome
$ vagrant rsync selenium-node-firefox
```

Run the tests with:

```
$ vagrant ssh app-debug-1 --command 'cd current && php admin/tool/behat/cli/run.php --profile=chrome'
```

Finally, to keep an eye on the test runs, a VNC viewer capable of displaying thumbnails of multiple servers (such as [VNC Thumbnail Viewer](https://thetechnologyteacher.wordpress.com/vncthumbnailviewer/) may be useful:

```
$ java -classpath VncThumbnailViewer.jar VncThumbnailViewer \
        HOST 192.168.120.105 PORT 5995 \
        HOST 192.168.120.105 PORT 5996 \
        HOST 192.168.120.105 PORT 5997 \
        HOST 192.168.120.105 PORT 5998
```

Further detail on using Behat is available in our [`app-debug` role documentation](../roles/app/debug.md#behat).

### PHPUnit

With the relevant configuration options present in your Moodle `config.php`, run the following to enable PHPUnit:

```
$ vagrant ssh app-debug-1 --command 'php current/admin/tool/phpunit/cli/init.php'
```

You may then run tests as follows:

```
$ vagrant ssh app-debug-1 --command 'php current/vendor/bin/phpunit'
```

<?php
// Configuration file via moodle-ubquiqitious docs/using/in-development.md

// Boilerplate
unset($CFG);
global $CFG;
$CFG = new stdClass();

// Database server

    //* PostgreSQL
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
    //*/

    /* MySQL
    $CFG->dbtype    = 'mysqli';
    $CFG->dblibrary = 'native';
    $CFG->dbhost    = '192.168.120.155';
    $CFG->dbname    = 'moodle';
    $CFG->dbuser    = 'moodle';
    $CFG->dbpass    = 'Password123';
    $CFG->prefix    = 'mdl_';
    $CFG->dboptions = array (
        'dbpersist' => 0,
        'dbport'    => 3306,
        'dbsocket'  => '',
    );
    //*/

    /* SQL Server
    $CFG->dbtype    = 'sqlsrv';
    $CFG->dblibrary = 'native';
    $CFG->dbhost    = 'tcp:192.168.120.155';
    $CFG->dbname    = 'moodle';
    $CFG->dbuser    = 'moodle';
    $CFG->dbpass    = 'Password123';
    $CFG->prefix    = 'mdl_';
    $CFG->dboptions = array(
        'dbpersist' => 0,
        'dbport'    => 1433,
        'dbsocket'  => '',
    );
    // Handle Saleslogix hook being broken with freetds
    $CFG->auth   = 'manual';
    //*/

// Base URLs
$CFG->wwwroot = 'http://192.168.120.50';
$CFG->admin   = 'admin';

// Data directory
$CFG->dataroot             = '/home/ubuntu/data';
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
$CFG->behat_dataroot      = dirname($CFG->dataroot) . '/behat';
$CFG->behat_faildump_path = dirname($CFG->dataroot) . '/behat-faildump';
$CFG->behat_wwwroot       = 'http://localhost/behat';
$CFG->behat_profiles = array(
    'chrome' => array(
        'extensions' => array(
            'Behat\MinkExtension\Extension' => array(
                'selenium2' => array(
                    'browser'     => 'chrome',
                    'browserName' => 'chrome',
                ),
            ),
        ),
    ),
    'firefox' => array(
        'extensions' => array(
            'Behat\MinkExtension\Extension' => array(
                'selenium2' => array(
                    'browser'     => 'firefox',
                    'browserName' => 'firefox',
                ),
            ),
        ),
    ),
    'iexplore' => array(
        'extensions' => array(
            'Behat\MinkExtension\Extension' => array(
                'selenium2' => array(
                    'browser'     => 'iexplore',
                    'browserName' => 'iexplore',
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
                    'wd_host' => "http://192.168.120.100:4444/wd/hub",
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
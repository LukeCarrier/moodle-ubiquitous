nvm:
  node_versions:
    - 8.10.0

platforms:
  dev.local:
    basename: moodle-dev
    role: moodle
    user:
      name: root
      home: /root
    nginx:
      access_log: /dev/stdout
      error_log: /dev/stderr
      client_max_body_size: 1024m
      fastcgi_pass: app:9000
      lanes:
        slow:
          location: ^((/admin|/backup|/course/report|/report)/.+\.php|/course/delete\.php)(/|$)
          fastcgi_read_timeout: 3600
          fastcgi_params:
            PHP_VALUE: |
              max_execution_time=3600
              memory_limit=1024m
        medium:
          location: ^(/theme/styles\.php)(/|$)
          fastcgi_read_timeout: 300
          fastcgi_params:
            PHP_VALUE: |
              max_execution_time=300
              memory_limit=1024m
        fast:
          location: ^(.+\.php)(/|$)
          fastcgi_read_timeout: 60
          fastcgi_params:
            PHP_VALUE: |
              max_execution_time=60
              memory_limit=128m
    php:
      fpm:
        listen: 9000
        pm: dynamic
        pm.max_children: 10
        pm.start_servers: 5
        pm.min_spare_servers: 5
        pm.max_spare_servers: 10
        pm.max_requests: 1000
      env:
        TZ: ':/etc/localtime'
      values:
        date.timezone: Europe/London
        memory_limit: 1024m
        post_max_size: 1024m
        upload_max_filesize: 1024m
        session.save_handler: files
        session.save_path: /root/var/run/php/session
        soap.wsdl_cache_dir: /root/var/run/php/wsdlcache
    pgsql:
      user:
        name: moodledev
        password: gibberish
      database:
        name: moodledev
        encoding: utf8
    moodle:
      dbtype: pgsql
      dblibrary: native
      dbhost: localhost
      dbname: moodledev
      dbuser: moodledev
      dbpass: gibberish
      prefix: mdl_
      dboptions:
        dbpersist: False
        dbport: 5432
      dataroot: /root/data
      directorypermissions: '0777'
      wwwroot: http://localhost
      sslproxy: false
      admin: admin
      pre_bootstrap: |
        $CFG->behat_prefix                = 'b_';
        $CFG->behat_dataroot              = '/root/data/behat';
        $CFG->behat_faildump_path         = '/root/data/behat-faildump';
        $CFG->behat_wwwroot               = 'http://localhost/behat';
        $CFG->behat_restart_browser_after = 900;
        $CFG->behat_profiles = array(
            'chrome' => array(
                'extensions' => array(
                    'Behat\MinkExtension' => array(
                        'selenium2' => array(
                            'browser' => 'chrome',
                            'capabilities' => array(
                                'browser' => 'chrome',
                                'browserName' => 'chrome',
                                'extra_capabilities' => array(
                                    'chromeOptions' => array(
                                        'args' => array(
                                            '--no-sandbox',
                                        ),
                                    ),
                                ),
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
                            'wd_host' => 'http://localhost:4444/wd/hub',
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

        $CFG->phpunit_prefix   = 'phpu_';
        $CFG->phpunit_dataroot = '/root/data/phpunit';

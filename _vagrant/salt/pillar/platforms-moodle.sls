{% macro moodle_platform(basename, dns_name, php_version, php_fpm_port) %}
  {{ dns_name }}.ubiquitous:
    basename: {{ basename }}
    role: moodle
    name: Local test site ({{ basename }})
    email: root@localhost
    lang: en
    logo: |
      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
      k7pSV9qf6f8Dh5MojxPVJ8wAAAAASUVORK5CYII=
    user:
      name: {{ basename }}
      home: /home/{{ basename }}
      group_members:
        - clamav
    nginx:
      client_max_body_size: 1024m
      fastcgi_pass: localhost:{{ php_fpm_port }}
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
      version: {{ php_version }}
      fpm:
        listen: {{ php_fpm_port }}
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
        session.save_path: /home/{{ basename }}/var/run/php/session
        soap.wsdl_cache_dir: /home/{{ basename }}/var/run/php/wsdlcache
    mssql:
      login:
        name: {{ basename }}
        password: P4$$word
      database:
        name: {{ basename }}
        options:
        alter:
          - COLLATE Latin1_General_CS_AS
          - SET ANSI_NULLS ON
          - SET QUOTED_IDENTIFIER ON
          - SET READ_COMMITTED_SNAPSHOT ON
      user:
        name: {{ basename }}
        roles:
          - db_owner
    pgsql:
      user:
        name: {{ basename }}
        password: P4$$word
      database:
        name: {{ basename }}
        encoding: utf8
    moodle:
      dbtype: pgsql
      dblibrary: native
      dbhost: pgsql0.ubiquitous
      dbname: {{ basename }}
      dbuser: {{ basename }}
      dbpass: P4$$word
      prefix: mdl_
      dboptions:
        dbpersist: False
        dbport: 5432
      dataroot: /home/{{ basename }}/data/base
      directorypermissions: '0777'
      wwwroot: http://{{ dns_name }}.ubiquitous
      sslproxy: False
      admin: admin
{% endmacro %}

platforms:
  {{ moodle_platform('moodlemaster', 'moodlemaster', '7.2', 9002) | indent(4) }}

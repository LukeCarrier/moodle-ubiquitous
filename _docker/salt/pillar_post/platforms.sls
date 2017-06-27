platforms:
  dev.local:
    basename: ubuntu
    user:
      name: ubuntu
      home: /home/ubuntu
    nginx:
      client_max_body_size: 1024m
    php:
      fpm:
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
        session.save_path: /home/ubuntu/var/run/php/session
        soap.wsdl_cache_dir: /home/ubuntu/var/run/php/wsdlcache
    pgsql:
      user:
        name: ubuntu
        password: gibberish
      database:
        name: ubuntu
        encoding: utf8
    moodle:
      dbtype: pgsql
      dblibrary: native
      dbhost: 192.168.120.150
      dbname: ubuntu
      dbuser: ubuntu
      dbpass: gibberish
      prefix: mdl_
      dboptions:
        dbpersist: False
        dbport: 5432
        dbsocket:
      dataroot: /home/ubuntu/data
      directorypermissions: '0777'
      wwwroot: http://192.168.120.50
      sslproxy: false
      admin: admin

platforms:
  dev.local:
    basename: vagrant
    role: moodle
    name: Local test site
    email: root@localhost
    lang: en
    user:
      name: vagrant
      home: /home/vagrant
    nginx:
      client_max_body_size: 1024m
      fastcgi_pass: localhost:9000
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
      # Uncomment and change $CFG->wwwroot to enable SSL
      #ssl:
      #  certificate: /etc/nginx/ssl/app-debug-1.moodle.crt
      #  certificate_key: /etc/nginx/ssl/app-debug-1.moodle.pem
    ssl:
      app-debug-1.moodle:
        public: |
          -----BEGIN CERTIFICATE-----
          MIIDUTCCAjmgAwIBAgIJAPMkzx8kCbyJMA0GCSqGSIb3DQEBCwUAMD8xGzAZBgNV
          BAMMEmFwcC1kZWJ1Zy0xLm1vb2RsZTETMBEGA1UECgwKVWJpcXVpdG91czELMAkG
          A1UEBhMCR0IwHhcNMTcwOTE4MTQ1MjEyWhcNMjcwOTE2MTQ1MjEyWjA/MRswGQYD
          VQQDDBJhcHAtZGVidWctMS5tb29kbGUxEzARBgNVBAoMClViaXF1aXRvdXMxCzAJ
          BgNVBAYTAkdCMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtMNiKEYI
          ox3odVD7EVjG7yAx4vLV8jRkEwSM+K0UthBV+C0H40VPBkDlYhBkB9hxhtSMoRkK
          M6/aA1V3epvgrfFQYcvytiCzNWgCSAtMrapfED9ZWqbVXJ6Q+YVfz4b9U18edw8I
          pQnQtn2Lw72JM/x6dXa6o8x+jPaqvSAm1e2CNC5R6UmjxQhGQnmm3DqS3bIEeK1t
          MjaQU+2rbtmUGPo2ZTvrvL5nqZCPTyN+bSOucOsVFUzbH2e6jqY0bSont450lSKX
          vFAsJBkRAyndlKl1yJU1IZOAbQTzNcZqDmjhTW3rmvuyE/lHhYWxESa1ZFvb/CLP
          E7mXi9SwzaPmLwIDAQABo1AwTjAdBgNVHQ4EFgQUUXxJyrM7xVlQ7I/IirBmWHt0
          u3swHwYDVR0jBBgwFoAUUXxJyrM7xVlQ7I/IirBmWHt0u3swDAYDVR0TBAUwAwEB
          /zANBgkqhkiG9w0BAQsFAAOCAQEAgzBVep1kRtL4DwklUoseky5jc/BRKPcy47D4
          wQiVwX01gbPO/WsaXqYvWOvrW5tzERvBkHs0E/u05XszcZzr+yFrdlNJezkWmy+7
          j50FroRYquxan0NiyfP8W1qoEadlDFLivXcuK0RA/+MifXRP/uZA4sX0YXbtjMhi
          sEOJaUnhVj3cMCtazwIVtlQN8EkTM/1ZTL2D5+sXkFDrRUh3xfkfcDVDK6nuaI6B
          aBx0uq0dYhjWDq98i3XGJRQOdtm14spfW5UAJxxB4awzvcxusSjdTm4t/5VjEs9V
          m/H7MMBVN43qWnFHLgosdNCrKhkC8ZTdNlRPpK4HEexUL6oyXw==
          -----END CERTIFICATE-----
        private: |
          -----BEGIN PRIVATE KEY-----
          MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC0w2IoRgijHeh1
          UPsRWMbvIDHi8tXyNGQTBIz4rRS2EFX4LQfjRU8GQOViEGQH2HGG1IyhGQozr9oD
          VXd6m+Ct8VBhy/K2ILM1aAJIC0ytql8QP1laptVcnpD5hV/Phv1TXx53DwilCdC2
          fYvDvYkz/Hp1drqjzH6M9qq9ICbV7YI0LlHpSaPFCEZCeabcOpLdsgR4rW0yNpBT
          7atu2ZQY+jZlO+u8vmepkI9PI35tI65w6xUVTNsfZ7qOpjRtKie3jnSVIpe8UCwk
          GREDKd2UqXXIlTUhk4BtBPM1xmoOaOFNbeua+7IT+UeFhbERJrVkW9v8Is8TuZeL
          1LDNo+YvAgMBAAECggEAKuxCQKHwpxsQ+dqS45mbE2knr2ZOW0cJhGKOPvaKdnkG
          kPnQZ60riKacUV7nAd3ph0StaAuUGpXlROlkh57ACU3F8pMFPS4in8nk0MquGIbe
          L/N6+kWnYGjesAF1sMezG7r4dvkA6n+cKdlB+Obmz4tiYMYip4aFfl+MR4B8+EsZ
          cPkYveG9ZHtLrarVP48AzPMnRJcSQc8p87EmlFcLoMhKA7vZhrwUFnDQv1e1F/9B
          DtbZz1jW2uMT4I784wwyk0yp7VkC3vKGxJaBnKzC7rGZRS7EqzhQSnEjjmm0aN1E
          7fqi/djAbtdxERK/ApceByiUCa2Ni5tNu5K+WZ13IQKBgQDcR+IUef8EC7onoS6G
          kU94kyT8TtPd+2Js73jubDm+vBhURpMQAqdUenEqBLewQOqveG7szgoCI+bp1j1+
          HAzw/fqWnFQFhOAbsg4lwO9xn9YM6HVetlQcC5uNV9JsXCNeal+yhhdBb+HJ6YnJ
          sVDf8Z9xeUlqVUHye38Q0XvRpwKBgQDSExQulJfJs5Gx6RMD9XA2fOPBIpsqdTfD
          7vuHIJpfWdtbGFhL+W4urjP40Iyy5yiPqot6dgCVFHnT6u4iKiRTlkmn6nrNcDv0
          TA3o3tRFiY+aHWrrWAzlzJyGi3NNkd6iYp5YQ3N0XY4IgeWYhbwYZX/9o35N7L6f
          Ux1uj/MIOQKBgQCOKfZGsNVcjxT9LpEQWAeqEYz1KQqjYPIMzCCH/2DlMA+jlEil
          NJE5fCw8qf7CyaKszFUKj472AqWslI/rK79OaRuoyAuR5EeemDN5OiNOeZFzkzLs
          hU+TKgqiFeO/+1b4QD6ywMeRe9uErCw49y7y2MXGPjibX5rIG9vNxuTaUQKBgF3I
          CKV2zoBL+snKvCNzSYH5pQ9ObKi6pYeBw6YiZugUTDnRl3FrS8XpHOiB6Z3gVho0
          z4l+7mmfN3fklCSKXac3G3Cr2+Ckrw8zeK4x89+LNqFdaqLfrvpTqrjhvjqt2Q7z
          Ka9LhVo4fbTMkHvTkBHwFgBcIYGWI88qoqP9/Uf5AoGARKqit8IBr7glKNntyjgF
          8GLKg7pWgFiSB2RrVwxBJjg8C4+ZUeZxPpkNrtkcIaQw/eybawpZ5Pit8Imo1ido
          afd8gETfkmb/1lxMS0MTOFcATng/2YMkTiEiPqxAGdGaEYRbqhg0ffIIvSaTb5c2
          dd6tiI/AFygmxGOUhCrdjRM=
          -----END PRIVATE KEY-----
    php:
      version: '7.2'
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
        session.save_path: /home/vagrant/var/run/php/session
        soap.wsdl_cache_dir: /home/vagrant/var/run/php/wsdlcache
    mssql:
      login:
        name: vagrant
        password: P4$$word
      database:
        name: vagrant
        options:
        alter:
          - COLLATE Latin1_General_CS_AS
          - SET ANSI_NULLS ON
          - SET QUOTED_IDENTIFIER ON
          - SET READ_COMMITTED_SNAPSHOT ON
      user:
        name: vagrant
        roles:
          - db_owner
    pgsql:
      user:
        name: vagrant
        password: gibberish
      database:
        name: vagrant
        encoding: utf8
    moodle:
      dbtype: pgsql
      dblibrary: native
      dbhost: 192.168.120.40
      dbname: vagrant
      dbuser: vagrant
      dbpass: gibberish
      prefix: mdl_
      dboptions:
        dbpersist: False
        dbport: 5432
      dataroot: /home/vagrant/data/base
      directorypermissions: '0777'
      wwwroot: http://192.168.120.80
      sslproxy: false
      admin: admin

nfs:
  common:
    default:
      NEED_IDMAPD: 'yes'
  imports:
    vagrant:
      mountpoint: /home/vagrant/data/base
      mountpoint_user: vagrant
      mountpoint_group: vagrant
      device: 192.168.120.75:vagrant

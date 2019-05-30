system:
  home_directories:
    - /home

php:
  packages:
    - php7.0-cli
    - php7.0-common
    - php7.0-curl
    - php7.0-dev
    - php7.0-fpm
    - php7.0-gd
    - php7.0-gmp
    - php7.0-intl
    - php7.0-json
    - php7.0-mbstring
    - php7.0-mcrypt
    - php7.0-opcache
    - php7.0-pgsql
    - php7.0-readline
    - php7.0-soap
    - php7.0-xml
    - php7.0-xmlrpc
    - php7.0-zip
    - php7.2-dev
    - php7.2-cli
    - php7.2-curl
    - libcurl4
    - php7.2-fpm
    - php7.2-gd
    - php7.2-gmp
    - php7.2-intl
    - php7.2-json
    - php7.2-mbstring
    - php7.2-opcache
    - php7.2-pgsql
    - php7.2-soap
    - php7.2-xml
    - php7.2-xmlrpc
    - php7.2-zip
  versions:
    '7.0':
      extension_api_version: '20151012'
      fpm:
        global:
          error_log: /var/log/php7.0-fpm/fpm.log
          pid: /run/php/php7.0-fpm.pid
    '7.2':
      extension_api_version: '20170718'
      fpm:
        global:
          error_log: /var/log/php7.2-fpm/fpm.log
          pid: /run/php/php7.2-fpm.pid

php-fpm:
  status_clients:
    - 127.0.0.1
    - 192.168.120.0/24

postfix:
  debconf:
    chattr: True
  main:
    relayhost: '192.168.120.60:1025'
    root_address: root@dev.local
    mynetworks:
      - 127.0.0.0/8
      - '[::ffff:127.0.0.0]/104'
      - '[::1]/128'
      - 192.168.120.0/24

system:
  home_directories:
    - /home

php:
  fpm:
    global:
      pid: /run/php/php7.0-fpm.pid
      error_log: /var/log/php7.0-fpm/fpm.log

php-fpm:
  status_clients:
    - 127.0.0.1
    - 192.168.120.0/24

mail-relay:
  relayhost: '192.168.120.200:1025'
  root_address: 'root@dev.local'

php:
  versions:
    '7.2':
      fpm:
        global:
          pid: /run/php/php7.2-fpm.pid
          error_log: /var/log/php7.2-fpm/fpm.log

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

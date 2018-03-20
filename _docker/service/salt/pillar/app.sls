nginx:
  user: root

php:
  fpm:
    global:
      pid: /run/php/php7.0-fpm.pid
      error_log: /dev/stderr

system:
  home_directories:
    - /home

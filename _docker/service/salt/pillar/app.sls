nginx:
  user: root
  access_log: /dev/stdout
  error_log: /dev/stderr

php:
  fpm:
    global:
      pid: /run/php/php7.2-fpm.pid
      error_log: /dev/stderr

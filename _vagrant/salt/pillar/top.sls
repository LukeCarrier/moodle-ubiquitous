base:
  '*':
    - base

  'roles:app-.+':
    - match: grain_pcre
    - app
    - nginx
    - php-fpm

  'roles:app-moodle':
    - match: grain
    - platforms-moodle
    - platforms-moodle-logos

  'roles:db-pgsql':
    - match: grain
    - db-pgsql
    - platforms-moodle

  'roles:gocd-agent':
    - match: grain
    - gocd

  'roles:gocd-server':
    - match: grain
    - gocd
    - nginx

  'roles:named':
    - match: grain
    - named

  'roles:selenium-.+':
    - match: grain_pcre
    - selenium

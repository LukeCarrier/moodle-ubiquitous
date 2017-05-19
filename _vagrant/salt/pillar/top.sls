base:
  '*':
    - base
    - platforms
    - platforms-logos

  'roles:app-base':
    - match: grain
    - app-base
    - nginx
    - php-fpm

  'roles:db-pgsql':
    - match: grain
    - db-pgsql

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

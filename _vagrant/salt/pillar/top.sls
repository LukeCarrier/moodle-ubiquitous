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

  'saml-platforms:identity-provider':
    - match: grain
    - platforms-saml-identity-provider

  'saml-platforms:identity-proxy':
    - match: grain
    - platforms-saml-identity-proxy

  'G@roles:redis and G@saml-platforms:identity-proxy':
    - match: compound
    - redis-identity-proxy

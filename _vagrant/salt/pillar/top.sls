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

  'roles:app-saml':
    - match: grain
    - platforms-saml-logos
  'G@roles:app-saml and G@saml-platforms:identity-provider':
    - match: compound
    - platforms-saml-identity-provider
  'G@roles:app-saml and G@saml-platforms:identity-proxy':
    - match: compound
    - platforms-saml-identity-proxy

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

  'roles:redis':
    - match: grain
    - redis

  'roles:redis-sentinel':
    - match: grain
    - redis-sentinel

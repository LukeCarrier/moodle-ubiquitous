base:
  '*':
    - base
    - platforms-moodle
    - platforms-moodle-logos

  'roles:app-.+':
    - match: grain_pcre
    - app
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

  'saml-platforms:identity-provider':
    - match: grain
    - platforms-saml-identity-provider

  'saml-platforms:identity-proxy':
    - match: grain
    - platforms-saml-identity-proxy

  'G@roles:redis and G@saml-platforms:identity-proxy':
    - match: compound
    - redis-identity-proxy

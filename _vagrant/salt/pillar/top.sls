base:
  '*':
    - admin

  'roles:app-.+':
    - match: grain_pcre
    - app

  'roles:web-.+':
    - match: grain_pcre
    - nginx
    - web

  'roles:.+-moodle':
    - match: grain_pcre
    - platforms-moodle
    - platforms-moodle-logos

  'roles:.+-saml':
    - match: grain_pcre
    - platforms-saml-logos
  'P@roles:.+-saml and G@saml-platforms:identity-provider':
    - match: compound
    - platforms-saml-identity-provider
  'P@roles:.+-saml and G@saml-platforms:identity-proxy':
    - match: compound
    - platforms-saml-identity-proxy

  'roles:db-mssql':
    - match: grain
    - db-mssql
    - platforms-moodle

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

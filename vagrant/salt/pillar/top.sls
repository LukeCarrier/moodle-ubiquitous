base:
  '*':
    - base
    - platforms

  'roles:app':
    - match: grain
    - app

  'roles:db-pgsql':
    - match: grain
    - db-pgsql

  'roles:(gocd-agent|gocd-server)':
    - match: grain_pcre
    - gocd

  'roles:selenium-.+':
    - match: grain_pcre
    - selenium

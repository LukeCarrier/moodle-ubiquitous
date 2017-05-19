base:
  '*':
    - base
    - platforms

  'roles:app-base':
    - match: grain
    - app-base

  'roles:db-pgsql':
    - match: grain
    - db-pgsql

  'roles:selenium-.+':
    - match: grain_pcre
    - selenium

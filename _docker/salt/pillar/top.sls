base:
  '*':
    - base
    - platforms

  'roles:app':
    - match: grain
    - app-moodle

  'roles:db-pgsql':
    - match: grain
    - db-pgsql

  'roles:selenium-.+':
    - match: grain_pcre
    - selenium

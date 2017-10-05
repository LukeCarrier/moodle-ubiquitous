base:
  '*':
    - base
    - platforms

  'roles:app-moodle':
    - match: grain
    - app

  'roles:db-pgsql':
    - match: grain
    - db-pgsql

  'roles:selenium-.+':
    - match: grain_pcre
    - selenium

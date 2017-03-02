base:
  '*':
    - base

  'roles:app':
    - match: grain
    - app

  'roles:db':
    - match: grain
    - db

  'roles:(gocd-agent|gocd-server)':
    - match: grain_pcre
    - gocd

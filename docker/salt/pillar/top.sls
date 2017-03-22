base:
  '*':
    - base
    - platforms

  'roles:app':
    - match: grain
    - app

  'roles:(gocd-agent|gocd-server)':
    - match: grain_pcre
    - gocd

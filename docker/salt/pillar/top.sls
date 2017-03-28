base:
  '*':
    - base
    - platforms

  'roles:app':
    - match: grain
    - app

  'roles:selenium-.+':
    - match: grain_pcre
    - selenium

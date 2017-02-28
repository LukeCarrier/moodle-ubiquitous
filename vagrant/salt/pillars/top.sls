base:
  '*':
    - base

  'roles:app':
    - match: grain
    - app

  'roles:db':
    - match: grain
    - db

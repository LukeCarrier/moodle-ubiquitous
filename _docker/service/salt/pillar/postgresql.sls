postgresql:
  client_authentication:
    - type: local
      database: all
      user: all
      method: peer
    - type: host
      database: all
      user: all
      address: 127.0.0.1/32
      method: md5
    - type: host
      database: all
      user: all
      address: ::1/128
      method: md5
    - type: host
      database: all
      user: all
      address: 0.0.0.0/0
      method: md5
  config:
    listen_addresses: '*'
  defer_creation: True

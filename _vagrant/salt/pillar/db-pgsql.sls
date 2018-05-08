postgresql:
  client_authentication:
    - type: host
      database: all
      user: all
      address: 192.168.120.0/24
      method: md5
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

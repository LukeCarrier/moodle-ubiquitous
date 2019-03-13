twemproxy:
  vagrant_lock:
    auto_eject_hosts: false
    distribution: ketama
    hash: fnv1a_64
    listen: /run/nutcracker/vagrant_lock.sock
    redis: true
    redis_db: 0
    server_connections: 10
    server_failure_limit: 1
    server_retry_timeout: 2000
    servers:
      - 127.0.0.1:16379:1
    tcpkeepalive: true
  vagrant_muc:
    auto_eject_hosts: false
    distribution: ketama
    hash: fnv1a_64
    listen: /run/nutcracker/vagrant_muc.sock
    redis: true
    redis_db: 1
    server_connections: 10
    server_failure_limit: 1
    server_retry_timeout: 2000
    servers:
      - 127.0.0.1:16379:1
    tcpkeepalive: true
  vagrant_session:
    auto_eject_hosts: false
    distribution: ketama
    hash: fnv1a_64
    listen: /run/nutcracker/vagrant_session.sock
    redis: true
    redis_db: 2
    server_connections: 10
    server_failure_limit: 1
    server_retry_timeout: 2000
    servers:
      - 127.0.0.1:16379:1
    tcpkeepalive: true

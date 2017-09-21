redis-sentinel:
  - daemonize: yes
  - pidfile: /var/run/redis/redis-sentinel.pid

  - port: 26379

  - dir: /var/lib/redis

  - sentinel:
    - monitor: master 192.168.120.61 6379 2

    - config-epoch: master 0
    - leader-epoch: master 13

    - down-after-milliseconds: master 30000
    - failover-timeout: master 180000
    - parallel-syncs: master 1

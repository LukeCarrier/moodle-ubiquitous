redis:
  - daemonize: True
  - pidfile: /var/run/redis/redis-server.pid

{% if salt['grains.get']('redis:slave', False) %}
  - slaveof: 192.168.120.61 6379
{% endif %}

  - port: 6379

  - tcp-backlog: 511
  - tcp-keepalive: 0
  - timeout: 60

  - lua-time-limit: 5000

  - client-output-buffer-limit:
    - normal 0 0 0
    - pubsub 32mb 8mb 60
    - slave 256mb 64mb 60

  - logfile: /var/log/redis/redis-server.log
  - loglevel: notice

  - databases: 1

  - dir: /var/lib/redis
  - dbfilename: dump.rdb
  - save:
    - 300 10
    - 60 10000
    - 900 1
  - stop-writes-on-bgsave-error: True
  - rdbchecksum: True
  - rdbcompression: True

  - appendfilename: appendonly.aof
  - appendfsync: everysec
  - appendonly: False
  - no-appendfsync-on-rewrite: False
  - aof-load-truncated: True
  - aof-rewrite-incremental-fsync: True
  - auto-aof-rewrite-min-size: 64mb
  - auto-aof-rewrite-percentage: 100

  - slave-priority: 100
  - slave-read-only: True
  - slave-serve-stale-data: True

  - repl-disable-tcp-nodelay: False
  - repl-diskless-sync-delay: 5
  - repl-diskless-sync: False

  - hz: 10
  - activerehashing: True
  - latency-monitor-threshold: 0
  - slowlog-log-slower-than: 10000
  - slowlog-max-len: 128
  - notify-keyspace-events: ''

  - hash-max-ziplist-entries: 512
  - hash-max-ziplist-value: 64
  - list-max-ziplist-entries: 512
  - list-max-ziplist-value: 64
  - set-max-intset-entries: 512
  - zset-max-ziplist-entries: 128
  - zset-max-ziplist-value: 64
  - hll-sparse-max-bytes: 3000

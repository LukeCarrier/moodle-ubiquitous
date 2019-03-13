redis-sentinel-tunnel:
  sentinel_addresses:
    - 127.0.0.1:26379
  databases:
    - name: master
      port: 16379

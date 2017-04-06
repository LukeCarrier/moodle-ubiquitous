named:
  resolvers:
    - 8.8.8.8 # Google public DNS
    - 4.2.2.4 # Level 3 customer DNS
  zones:
    moodle:
      ttl: 604800
      soa:
        fqdn: named.moodle
        hostmaster: hostmaster.named.moodle
        serial: 1
        refresh: 604800
        retry: 86400
        expire: 2419200
        negative_cache_ttl: 604800
      records:
        - '@ IN NS named.moodle.'
        - salt IN A 192.168.120.5
        - gocd IN A 192.168.120.10
        - named IN A 192.168.120.15
        - app-debug-1 IN A 192.168.120.50
        - selenium-hub IN A 192.168.120.100
        - selenium-node-chrome IN A 192.168.120.105
        - selenium-node-firefox IN A 192.168.120.110
        - db-pgsql-1 IN A 192.168.120.150
        - mail-debug IN A 192.168.120.200
    120.168.192.in-addr.arpa:
      ttl: 604800
      soa:
        fqdn: named.moodle
        hostmaster: hostmaster.named.moodle
        serial: 1
        refresh: 604800
        retry: 86400
        expire: 2419200
        negative_cache_ttl: 604800
      records:
        - '@ IN NS named.'
        - 15 IN PTR named.moodle.
        - 5 IN PTR salt.moodle.
        - 10 IN PTR gocd.moodle.
        - 50 IN PTR app-debug-1.moodle.
        - 100 IN PTR selenium-hub.moodle.
        - 105 IN PTR selenium-node-chrome.moodle.
        - 110 IN PTR selenium-node-firefox.moodle.
        - 150 IN PTR db-pgsql-1.moodle.
        - 200 IN PTR mail-debug.moodle.

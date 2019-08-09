gocd-agent:
  server: https://192.168.120.20:8154/go

gocd-server:
  users:
    lcarrier: sumK1vbrhQjdahTPpwS61/Bfb7E=

gocd:
  - '%go ALL=(ALL) NOPASSWD: /usr/bin/salt-call ubiquitous_platform.*'

#
# Ubiquitous Redis
#
# @author Sascha Peter <sascha.o.peter@gmail.com>
# @copyright 2017 Sascha Peter
#

include:
  - base
  - redis-base

#
# Redis default configuration
#

# redis.config.keys.set:
#   redis.string:
#     - value: string data
#     - host: {{ pillar['redis']['master']['host'] | yaml_squote }}
#     - port: {{ pillar['redis']['master']['port'] }}
#     - db: {{ pillar['redis']['master']['db'] }}
#     - password: {{ pillar['redis']['master']['password'] }}

redis.system.overcommit-memory:
  sysctl.present:
    - name: vm.overcommit_memory
    - value: 1

redis.config.values.set:
  file.managed:
    - name: /etc/redis/redis.conf
    - source: salt://redis-master/redis.conf.jinja
    - template: jinja
    - watch_in:
      - service: redis.service.reload

redis.service.reload:
  service.running:
    - name: redis
    - enable: True

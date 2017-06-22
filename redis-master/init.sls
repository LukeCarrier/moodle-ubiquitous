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

redis.config.keys.set:
  redis.string:
    - value: string data
    - host: {{ pillar['redis']['master']['host'] | yaml_squote }}
    - port: {{ pillar['redis']['master']['port'] }}
    - db: {{ pillar['redis']['master']['db'] }}
    - password: {{ pillar['redis']['master']['password'] }}

# redis.service:
#   service.running:
#     - name: redis
#     - enable: True
#     - require:
#       - pkg: redis-server

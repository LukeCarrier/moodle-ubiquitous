#
# Ubiquitous Redis
#
# @author Sascha Peter <sascha.o.peter@gmail.com>
# @copyright 2017 Sascha Peter
#

include:
  - base

#
# OS software requirements
#

os.packages:
  pkg.installed:
  - pkgs:
    - python-redis
    - redis-server

redis.iptables.redis:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - proto: tcp
    - dport: 6379
    - save: True
    - require:
      - iptables: iptables.default.input.established
    - require_in:
      - iptables: iptables.default.input.drop

redis.system.overcommit-memory:
  sysctl.present:
    - name: vm.overcommit_memory
    - value: 1

redis.config.values.set:
  file.managed:
    - name: /etc/redis/redis.conf
    - source: salt://redis/redis.conf.jinja
    - template: jinja
    - watch_in:
      - service: redis.service.reload

redis.service.reload:
  service.running:
    - name: redis
    - enable: True

#
# Ubiquitous Redis
#
# @author Sascha Peter <sascha.o.peter@gmail.com>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - base

redis.pkgs:
  pkg.installed:
    - pkgs:
      - redis-server
      - redis-tools

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

redis.sysctl.overcommit-memory:
  sysctl.present:
    - name: vm.overcommit_memory
    - value: 1

redis.conf:
  file.managed:
    - name: /etc/redis/redis.conf
    - source: salt://redis/redis/redis.conf.jinja
    - template: jinja
    - user: redis
    - group: redis
    - mode: 0640

redis.service:
  service.running:
    - name: redis-server
    - enable: True
    - require:
      - redis.pkgs
      - redis.sysctl.overcommit-memory

redis.restart:
  cmd.run:
    - name: systemctl restart redis-server
    - watch:
      - redis.conf

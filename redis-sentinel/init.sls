#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

redis-sentinel.pkgs:
  pkg.latest:
    - name: redis-sentinel

redis-sentinel.conf:
  file.managed:
    - name: /etc/redis/sentinel.conf
    - source: salt://redis-sentinel/redis-sentinel/sentinel.conf.jinja
    - template: jinja
    - user: redis
    - group: redis
    - mode: 0640

redis-sentinel.service:
  service.running:
    - name: redis-sentinel
    - enable: True
    - require:
      - redis-sentinel.pkgs

redis-sentinel.restart:
  cmd.run:
    - name: systemctl restart redis-sentinel
    - watch:
      - redis-sentinel.conf

#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

redis-sentinel-tunnel.pkgs:
  pkg.latest:
    - name: sentinel-tunnel

redis-sentinel-tunnel.config:
  file.managed:
    - name: /etc/sentinel-tunnel/sentinel-tunnel.json
    - source: salt://redis-sentinel-tunnel/sentinel-tunnel/sentinel-tunnel.json.jinja
    - template: jinja
    - user: sentinel-tunnel
    - group: root
    - mode: 0644
    - require:
      - pkg: redis-sentinel-tunnel.pkgs
    - onchanges:
      - cmd: redis-sentinel-tunnel.reload

redis-sentinel-tunnel.service:
  service.running:
    - name: sentinel-tunnel
    - enable: True
    - require:
      - pkg: redis-sentinel-tunnel.pkgs
      - file: redis-sentinel-tunnel.config

redis-sentinel-tunnel.reload:
  cmd.run:
    - name: systemctl restart sentinel-tunnel

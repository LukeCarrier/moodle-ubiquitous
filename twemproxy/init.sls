#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

twemproxy.pkgs:
  pkg.latest:
    - name: nutcracker

twemproxy.config:
  file.serialize:
    - name: /etc/nutcracker/nutcracker.yml
    - formatter: yaml
    - dataset_pillar: twemproxy
    - user: nutcracker
    - group: root
    - mode: 0640
    - require:
      - pkg: twemproxy.pkgs
    - onchanges:
      - cmd: twemproxy.reload

twemproxy.service:
  service.running:
    - name: nutcracker
    - enable: True
    - require:
      - pkg: twemproxy.pkgs
      - file: twemproxy.config

twemproxy.reload:
  cmd.run:
    - name: systemctl restart nutcracker

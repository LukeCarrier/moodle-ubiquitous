#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

sshd:
  pkg.installed:
    - name: openssh-server

sshd.sshd_config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://sshd/sshd/sshd_config.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: sshd

{% if pillar['systemd']['apply'] %}
sshd.service:
  service.running:
    - name: ssh
    - enable: True
    - reload: True
    - require:
      - pkg: openssh-server
    - watch:
      - file: sshd.sshd_config
{% endif %}

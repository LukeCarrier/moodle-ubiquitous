#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

systemd.journald.journald.conf:
  file.managed:
    - name: /etc/systemd/journald.conf
    - source: salt://systemd/systemd/journald.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

{% for user in salt['pillar.get']('systemd:journal:group_members', []) %}
systemd.journald.group:
  user.present:
    - name: {{ user }}
    - groups:
      - systemd-journal
{% endfor %}

systemd.journald.service:
  service.running:
    - name: systemd-journald
    - full_restart: True
    - watch:
      - file: systemd.journald.journald.conf

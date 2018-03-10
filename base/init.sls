#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

#
# Hosts file
#

/etc/hosts:
  file.managed:
    - source: salt://base/network/hosts.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

#
# SaltStack APT repository
#

/etc/apt/sources.list.d/saltstack.list:
  file.managed:
    - source: salt://base/lists/saltstack.list
    - user: root
    - group: root
    - mode: 0644

#
# systemd
#

{% if pillar['systemd']['apply'] %}
systemd.journald:
  file.managed:
    - name: /etc/systemd/journald.conf
    - source: salt://base/systemd/journald.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
  service.running:
    - name: systemd-journald
    - full_restart: True
    - watch:
      - file: systemd.journald
{% endif %}

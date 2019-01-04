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

{% for unit, files in salt['pillar.get']('systemd:system', {}).items() %}
systemd.system.{{ unit }}:
  file.directory:
    - name: /etc/systemd/system/{{ unit }}.d
    - user: root
    - group: root
    - mode: 0755

  {% for file in files.keys() %}
systemd.system.{{ unit }}.{{ file }}:
  file.managed:
    - name: /etc/systemd/system/{{ unit }}.d/{{ file }}.conf
    - contents_pillar: systemd:system:{{ unit }}:{{ file }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - file: systemd.system.{{ unit }}
    - onchanges:
      - cmd: systemd.system.daemon-reload
  {% endfor %}
{% endfor %}

systemd.system.daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload

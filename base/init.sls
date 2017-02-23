#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

#
# Administrative user
#

admin:
  user.present:
    - name: {{ pillar['admin']['name'] }}
    - password: {{ pillar['admin']['password'] }}
    - fullname: Administrative user
    - shell: /bin/bash
    - home: {{ pillar['admin']['home'] }}
    - gid_from_name: True
    - groups: {{ pillar['admin']['groups'] }}

admin.ssh:
  file.directory:
    - name: {{ pillar['admin']['home'] }}/.ssh
    - user: {{ pillar['admin']['name'] }}
    - group: admin
    - mode: 0700
    - require:
      - user: {{ pillar['admin']['name'] }}

{% if 'authorized_keys' in pillar['admin'] %}
admin.ssh.authorized_keys:
  file.managed:
    - name: {{ pillar['admin']['home'] }}/.ssh/authorized_keys
    - template: jinja
    - source: salt://base/admin/authorized_keys.jinja
    - user: {{ pillar['admin']['name'] }}
    - group: {{ pillar['admin']['name'] }}
    - mode: 0600
    - require:
      - file: admin.ssh
{% endif %}

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
# SSH daemon
#

ssh:
  pkg.installed:
    - name: openssh-server
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://base/sshd/sshd_config
    - require:
      - pkg: openssh-server
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: openssh-server
    - watch:
      - file: /etc/ssh/sshd_config

#
# NTP daemon
#

ntp:
  pkg.installed:
    - pkgs:
      - ntp
      - ntpdate
  service.running:
    - name: ntp
    - enable: True
    - require:
      - pkg: ntp

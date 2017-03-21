#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

#
# Default firewall policy
#

ufw.disable:
  service.disabled:
    - name: ufw

ufw.dead:
  service.dead:
    - name: ufw

iptables.persistent:
  pkg.installed:
    - pkgs:
      - iptables-persistent

iptables.default.input.established:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - match: conntrack
    - ctstate: RELATED,ESTABLISHED
    - save: True

iptables.default.input.drop:
  iptables.set_policy:
    - chain: INPUT
    - policy: DROP
    - save: True
    - require:
      - iptables: iptables.default.input.local
      - iptables: iptables.default.input.established

iptables.default.input.local:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - source: 127.0.0.1
    - save: True

iptables.default.forward.local:
  iptables.append:
    - chain: FORWARD
    - jump: ACCEPT
    - source: 127.0.0.1
    - save: True

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
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - proto: tcp
    - dport: 22
    - save: True
    - require_in:
      - iptables.default.input.drop

#
# Useful administrative tools
#

admin.utilities:
  pkg.installed:
    - pkgs:
      - git
      - htop
      - tree
      - vim

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

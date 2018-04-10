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
# Locales
#

locales.pkg:
  pkg.latest:
    - name: locales

{% for locale in pillar['locales']['present'] %}
locales.present.{{ locale }}:
  locale.present:
    - name: {{ locale }}
    - require:
      - pkg: locales.pkg
{% endfor %}

locales.default:
  locale.system:
    - name: {{ pillar['locales']['default'] }}

#
# Administrative user
#

admin:
  group.present:
    - name: admin
    - system: True

{% for username, user in pillar['users'].items() %}
user.{{ username }}:
  user.present:
    - name: {{ username }}
    - password: {{ user['password'] }}
    - fullname: {{ user['fullname'] }}
    - shell: /bin/bash
    - home: {{ user['home'] }}
    - groups: {{ user['groups'] }}
    - require:
      - group: admin

user.{{ username }}.ssh:
  file.directory:
    - name: {{ user['home'] }}/.ssh
    - user: {{ username }}
    - group: {{ username }}
    - mode: 0700
    - require:
      - user: {{ username }}

{% if 'authorized_keys' in user %}
user.{{ username }}.ssh.authorized_keys:
  file.managed:
    - name: {{ user['home'] }}/.ssh/authorized_keys
    - contents_pillar: users:{{ username }}:authorized_keys
    - user: {{ username }}
    - group: {{ username }}
    - mode: 0600
    - require:
      - file: user.{{ username }}.ssh
{% endif %}
{% endfor %}

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

#
# SSH daemon
#

ssh:
  pkg.installed:
    - name: openssh-server
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://base/sshd/sshd_config.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: openssh-server

{% if pillar['systemd']['apply'] %}
ssh.service:
  service.running:
    - name: ssh
    - enable: True
    - reload: True
    - require:
      - pkg: openssh-server
    - watch:
      - file: /etc/ssh/sshd_config
{% endif %}

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

{% if pillar['systemd']['apply'] %}
ntp.service:
  service.running:
    - name: ntp
    - enable: True
    - require:
      - pkg: ntp
{% endif %}

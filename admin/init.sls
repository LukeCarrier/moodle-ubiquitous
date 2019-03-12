#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% if 'packages' in pillar %}
admin.packages:
  pkg.installed:
    - pkgs:
{% for package in pillar['packages'] %}
      - {{ package }}
{% endfor %}
{% endif %}

admin.group:
  group.present:
    - name: admin
    - system: True

{% for home_directory in salt['pillar.get']('system:home_directories', []) %}
admin.homes.{{ home_directory }}:
  file.directory:
    - name: {{ home_directory }}
    - user: root
    - group: root
    - mode: 755
{% endfor %}

{% for username, user in salt['pillar.get']('users', {}).items() %}
admin.user.{{ username }}:
  user.present:
    - name: {{ username }}
{% if 'password' in user %}
    - password: {{ user['password'] }}
{% endif %}
    - fullname: {{ user['fullname'] }}
    - shell: /bin/bash
    - home: {{ user['home'] }}
    - gid_from_name: True
    - groups: {{ user['groups'] }}
    - require:
      - group: admin.group

admin.user.{{ username }}.ssh:
  file.directory:
    - name: {{ user['home'] }}/.ssh
    - user: {{ username }}
    - group: {{ username }}
    - mode: 0700
    - require:
      - user: {{ username }}

{% if 'authorized_keys' in user %}
admin.user.{{ username }}.ssh.authorized_keys:
  file.managed:
    - name: {{ user['home'] }}/.ssh/authorized_keys
    - contents_pillar: users:{{ username }}:authorized_keys
    - user: {{ username }}
    - group: {{ username }}
    - mode: 0600
    - require:
      - file: admin.user.{{ username }}.ssh
{% endif %}
{% endfor %}

{% if 'locales' in pillar %}
admin.locales.pkg:
  pkg.latest:
    - name: locales

{% for locale in salt['pillar.get']('locales:present', []) %}
admin.locales.present.{{ locale }}:
  locale.present:
    - name: {{ locale }}
    - require:
      - pkg: admin.locales.pkg
{% endfor %}

{% if 'default' in pillar['locales'] %}
admin.locales.default:
  locale.system:
    - name: {{ pillar['locales']['default'] }}
{% endif %}
{% endif %}

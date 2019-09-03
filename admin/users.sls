{% from 'admin/map.jinja' import admin with context %}

{% for home_directory in admin.users.home_directories %}
admin.users.homes.{{ home_directory }}:
  file.directory:
    - name: {{ home_directory }}
    - user: root
    - group: root
    - mode: 755
{% endfor %}

admin.users.admin_group:
  group.present:
    - name: admin
    - system: True

{% for username, user in admin.users.users.items() %}
admin.user.{{ username }}.user:
  user.present:
    - name: {{ username }}
  {% if 'password' in user %}
    - password: {{ user['password'] }}
  {% endif %}
    - fullname: {{ user['fullname'] }}
    - shell: /bin/bash
    - home: {{ user['home'] }}
    - groups: {{ user['groups'] }}

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

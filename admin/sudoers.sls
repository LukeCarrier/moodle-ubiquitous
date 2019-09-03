{% from 'admin/map.jinja' import admin with context %}

{% for group, sudoers in admin.sudoers.items() %}
admin.sudoers.{{ group }}:
  file.managed:
    - name: /etc/sudoers.d/{{ group }}
    - contents: {{ sudoers | yaml }}
    - user: root
    - group: root
    - mode: 0440
{% endfor %}

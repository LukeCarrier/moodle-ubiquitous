{% from 'admin/map.jinja' import admin with context %}

{% for repo in admin.packages.repositories %}
admin.packages.repositories.{{ repo.humanname | default(loop.index0) }}:
  pkgrepo.managed:
    {{ repo | yaml }}
{% endfor %}

{% if 'packages' in admin.packages %}
admin.packages.packages:
  pkg.installed:
    - pkgs: {{ admin.packages.packages | yaml }}
{% endif %}

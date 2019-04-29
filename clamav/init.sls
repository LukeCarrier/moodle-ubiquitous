{% from 'clamav/map.jinja' import clamav with context %}

clamav.pkgs:
  pkg.latest:
    - pkgs: {{ clamav.packages | yaml }}

{% for service, status in clamav.services.items() %}
clamav.services.{{ service }}:
  service.{{ 'enabled' if status else 'disabled' }}:
    - name: {{ clamav.service_names.get(service) }}
{% endfor %}

{% for service, config in clamav.config.items() %}
  {% for option, value in config %}
file.line:
  clamav.config.{{ service }}.{{ config }}:
    - name: {{ clamav.config_files.get(service) }}
    - mode: replace
    - match: '^{{ config }} '
    - content: '{{ name }} {{ value | yaml }}'
  {% endfor %}
{% endfor %}

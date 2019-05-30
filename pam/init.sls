{% from 'pam/map.jinja' import pam with context %}

pam.pkgs:
  pkg.latest:
    - pkgs: {{ pam.packages | yaml }}

{% for service, rules in pam.services.items() %}
pam.service.{{ service }}:
  file.managed:
    - name: /etc/pam.d/{{ service }}
    - contents: {{ rules | yaml }}
    - owner: root
    - group: root
    - mode: 0640
{% endfor %}

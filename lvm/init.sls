{% from 'lvm/map.jinja' import lvm with context %}

lvm.config.lvm.conf:
  file.managed:
    - name: /etc/lvm/lvm.conf
    - contents: {{ lvm.config['lvm.conf'] | yaml }}
    - user: root
    - group: root
    - mode: 0644

{% for service, enabled in lvm.services.items() %}
lvm.service.{{ service }}:
  service.{{ 'running' if enabled else 'dead' }}:
    - name: {{ service }}
    - enable: {{ True if enabled else False }}
{% endfor %}

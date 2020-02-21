{% from 'logrotate/map.jinja' import logrotate with context %}

{% for service in logrotate.services.keys() %}
logrotate.service.{{ service }}:
  file.managed:
    - name: /etc/logrotate.d/{{ service }}
    - contents_pillar: logrotate:services:{{ service }}
      config: {{ config | yaml }}
    - user: root
    - group: root
    - mode: 0644
{% endfor %}

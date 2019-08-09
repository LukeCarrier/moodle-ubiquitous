{% from 'drbd/map.jinja' import drbd with context %}

drbd.pkgs:
  pkg.latest:
    - pkgs: {{ drbd.packages | yaml }}

drbd.drbd.conf:
  file.managed:
    - name: /etc/drbd.conf
    - contents: {{ drbd['drbd.conf'] }}
    - user: root
    - group: root
    - mode: 0644

{% for file in drbd.get('drbd.d', []) %}
drbd.drbd.d.{{ file }}:
  file.managed:
    - name: /etc/drbd.d/{{ file }}
    - contents_pillar: drbd:drbd.d:{{ file }}
    - user: root
    - group: root
    - mode: 0644
{% endfor %}

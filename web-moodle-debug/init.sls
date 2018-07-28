#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - web-moodle
  - web-moodle-debug

{% for domain, platform in salt['pillar.get']('platforms', {}).items() if 'moodle' in platform %}
web-moodle-debug.{{ domain }}.nginx:
  file.managed:
    - name: /etc/nginx/sites-extra/{{ platform['basename'] }}.moodle-debug.conf
    - source: salt://web-moodle-debug/nginx/platform.moodle-debug.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
    - user: root
    - group: root
    - mode: 0644
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - web-moodle-debug.nginx.reload
{% endif %}
{% endfor %}

{% if pillar['systemd']['apply'] %}
web-moodle-debug.nginx.reload:
  cmd.run:
    - name: systemctl reload nginx || systemctl restart nginx
{% endif %}

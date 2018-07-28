#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - web-base

{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
web-debug.{{ domain }}.nginx:
  file.managed:
    - name: /etc/nginx/sites-extra/{{ platform['basename'] }}.debug.conf
    - source: salt://web-debug/nginx/platform.debug.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
    - user: root
    - group: root
    - mode: 0644
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - web-debug.nginx.reload
{% endif %}
{% endfor %}

{% if pillar['systemd']['apply'] %}
web-debug.nginx.reload:
  cmd.run:
    - name: systemctl reload nginx || systemctl restart nginx
{% endif %}

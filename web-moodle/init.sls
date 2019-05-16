#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% from 'web-base/macros.sls' import web_platform, web_restarts %}
{% from 'web-lets-encrypt/macros.sls' import lets_encrypt_all %}

include:
  - web-base
  - ubiquitous-cli-base

{% for domain, platform in salt['pillar.get']('platforms', {}).items() if 'moodle' in platform %}
{{ web_platform('moodle', domain, platform) }}

web-moodle.{{ domain }}.nginx.available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - source: salt://web-moodle/nginx/platform.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
      instance: blue
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx.pkgs
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: web-moodle.nginx.restart
{% endif %}

web-moodle.{{ domain }}.nginx.enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ platform['basename'] }}.conf
    - target: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - require:
      - file: web-moodle.{{ domain }}.nginx.available
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: web-moodle.nginx.restart
{% endif %}
{% endfor %}

{{ lets_encrypt_all('moodle', platforms) }}

{{ web_restarts('moodle') }}

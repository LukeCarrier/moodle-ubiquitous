#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - base
  - app-base

#
# Supporting packages
#

ghostscript:
  pkg.installed

#
# Moodle platforms
#

{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
moodle.{{ domain }}.nginx.available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - source: salt://app-moodle/nginx/platform.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
      instance: blue
      platform: {{ platform }}
    - user: root
    - group: root
    - mode: 0644
{% if pillar['systemd']['apply'] %}
    - require:
      - pkg: nginx
{% endif %}

moodle.{{ domain }}.nginx.enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ platform['basename'] }}.conf
    - target: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - require:
      - file: moodle.{{ domain }}.nginx.available
{% if pillar['systemd']['apply'] %}
    - require_in:
      - service: nginx.reload
{% endif %}

moodle.{{ domain }}.data:
  file.directory:
    - name: {{ platform['user']['home'] }}/data
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: moodle.{{ domain }}.home

moodle.{{ domain }}.config:
  file.managed:
    - name: {{ platform['user']['home'] }}/config.php
    - source: salt://app-moodle/moodle/config.php.jinja
    - template: jinja
    - context:
      cfg: {{ platform['moodle'] }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0660
{% endfor %}

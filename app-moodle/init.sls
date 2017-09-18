#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

{% from 'app-base/macros.sls' import app_platform, app_restarts %}
{% from 'app-lets-encrypt/macros.sls' import lets_encrypt_all %}

include:
  - base
  - app-base
  - app-ubiquitous-dirs

#
# Supporting packages
#

app-moodle.dependencies:
  pkg.installed:
    - pkgs:
      - ghostscript
      - unoconv

#
# Configuration installation
#

app-moodle.install-config:
  file.managed:
    - name: /usr/local/ubiquitous/bin/ubiquitous-install-config-moodle
    - source: salt://app-moodle/local/bin/ubiquitous-install-config-moodle
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: app-ubiquitous-dirs.bin

#
# Moodle platforms
#

{% for domain, platform in salt['pillar.get']('platforms', {}).items() if 'moodle' in platform %}
{{ app_platform('moodle', domain, platform) }}

app-moodle.{{ domain }}.nginx.available:
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
    - require:
      - pkg: nginx
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: app-moodle.nginx.restart
{% endif %}

app-moodle.{{ domain }}.nginx.enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ platform['basename'] }}.conf
    - target: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - require:
      - file: app-moodle.{{ domain }}.nginx.available
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: app-moodle.nginx.restart
{% endif %}

app-moodle.{{ domain }}.data:
  file.directory:
    - name: {{ platform['user']['home'] }}/data
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: app-base.{{ domain }}.home

app-moodle.{{ domain }}.localcache:
  file.directory:
    - name: {{ platform['user']['home'] }}/data/localcache
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: app-moodle.{{ domain }}.data

app-moodle.{{ domain }}.config:
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

{{ app_restarts('moodle') }}

{{ lets_encrypt_all('moodle', platforms) }}

#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% from 'app-base/macros.sls' import app_platform, app_restarts %}

include:
  - app-base
  - ubiquitous-dirs

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
      - file: ubiquitous-dirs.bin

#
# Moodle platforms
#

{% for domain, platform in salt['pillar.get']('platforms', {}).items() if 'moodle' in platform %}
{{ app_platform('moodle', domain) }}

app-moodle.{{ domain }}.data:
  file.directory:
    - name: {{ platform['user']['home'] }}/data
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: app.{{ domain }}.home

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
      domain: {{ domain }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0660
{% endfor %}

{{ app_restarts('moodle') }}

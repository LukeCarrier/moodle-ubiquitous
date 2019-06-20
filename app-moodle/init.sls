#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% from 'php/macros.sls' import app_platform, app_restarts %}

include:
  - php
  - ubiquitous-cli-base

#
# Supporting packages
#

app-moodle.dependencies:
  pkg.installed:
    - pkgs:
      - ghostscript
      - unoconv

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
{% endfor %}

{{ app_restarts('moodle') }}

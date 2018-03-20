#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - app-moodle
  - app-default-release

{% for domain, platform in salt['pillar.get']('platforms', {}).items() if 'moodle' in platform %}
app-moodle-default-release.{{ domain }}.data:
  file.directory:
    - name: {{ platform['moodle']['dataroot'] }}
    - user: {{ platform ['user']['name'] }}
    - group: {{ platform ['user']['name'] }}
    - mode: 0770
    - require:
      - user: app.{{ domain }}.user
      - file: app.{{ domain }}.home
{% endfor %}

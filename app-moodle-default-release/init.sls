#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - app-moodle
  - app-default-release

{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
app-moodle-default-release.{{ domain }}.data:
  file.directory:
    - name: {{ platform['moodle']['dataroot'] }}
    - user: {{ platform ['user']['name'] }}
    - group: {{ platform ['user']['name'] }}
    - mode: 0770
    - require:
      - user: app-base.{{ domain }}.user
      - file: app-base.{{ domain }}.home
{% endfor %}

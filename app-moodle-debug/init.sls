#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - app-moodle
  - app-debug

{% for domain, platform in salt['pillar.get']('platforms', {}).items() if 'moodle' in platform %}
{% set behat_faildump = platform['user']['home'] + '/data/behat-faildump' %}

app-moodle-debug.{{ domain }}.behat-faildump:
  file.directory:
  - name: {{ behat_faildump }}
  - user: {{ platform['user']['name'] }}
  - group: {{ platform['user']['name'] }}
  - mode: 0770
  - require:
    - file: app-moodle.{{ domain }}.data

{% if pillar['acl']['apply'] %}
app-moodle-debug.{{ domain }}.behat-faildump.acl:
  acl.present:
  - name: {{ behat_faildump }}
  - acl_type: user
  - acl_name: {{ pillar['app']['php']['fpm']['socket_owner'] }}
  - perms: rx
  - require:
    - app-moodle-debug.{{ domain }}.behat-faildump
{% endif %}
{% endfor %}

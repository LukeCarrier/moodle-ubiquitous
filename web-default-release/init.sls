#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - web-base

{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
{% if 'default_release' in platform %}
{% set release_dir = platform['user']['home'] + '/releases/' + platform['default_release'] %}

web-default-release.{{ domain }}.release:
  file.directory:
    - name: {{ release_dir }}
    - user: {{ platform ['user']['name'] }}
    - group: {{ platform ['user']['name'] }}
    - mode: 0755
    - require:
      - file: web.{{ domain }}.releases

web-default-release.{{ domain }}.current:
  file.symlink:
    - name: {{ platform['user']['home'] }}/current
    - target: {{ release_dir }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - require:
      - file: web-default-release.{{ domain }}.release
{% endif %}
{% endfor %}

{% if pillar['systemd']['apply'] %}
web-default-release.nginx.reload:
  cmd.run:
    - name: systemctl reload nginx || systemctl restart nginx
{% endif %}
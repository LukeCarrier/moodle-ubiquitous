#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% from 'php/map.sls' import php with context %}

include:
  - php

{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
{% if 'default_release' in platform %}
{% set release_dir = platform['user']['home'] + '/releases/' + platform['default_release'] %}

app-default-release.{{ domain }}.release:
  file.directory:
    - name: {{ release_dir }}
    - user: {{ platform ['user']['name'] }}
    - group: {{ platform ['user']['name'] }}
    - mode: 0755
    - require:
      - file: app.{{ domain }}.releases

app-default-release.{{ domain }}.current:
  file.symlink:
    - name: {{ platform['user']['home'] }}/current
    - target: {{ release_dir }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - require:
      - file: app-default-release.{{ domain }}.release
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - cmd: app-default-release.php-fpm.reload
{% endif %}

app-default-release.{{ domain }}.php-fpm.blue:
  file.symlink:
    - name: /etc/php/{{ php.version }}/fpm/pools-enabled/{{ platform['basename'] }}.blue.conf
    - target: /etc/php/{{ php.version }}/fpm/pools-available/{{ platform['basename'] }}.blue.conf
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - cmd: app-default-release.php-fpm.reload
{% endif %}
{% endif %}
{% endfor %}

{% if pillar['systemd']['apply'] %}
app-default-release.php-fpm.reload:
  cmd.run:
    - name: systemctl reload php{{ php.version }}-fpm || systemctl restart php{{ php.version }}-fpm
{% endif %}

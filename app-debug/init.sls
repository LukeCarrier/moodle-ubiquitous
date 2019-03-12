#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% from 'php/map.jinja' import php with context %}

include:
  - php

app-debug.php.xdebug:
  pkg.installed:
    - pkgs:
      - php-xdebug

{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
{% set behat_faildump = platform['user']['home'] + '/data/behat-faildump' %}
app-debug.{{ domain }}.php-fpm:
  file.managed:
    - name: /etc/php/{{ php.version }}/fpm/pools-extra/{{ platform['basename'] }}.debug.conf
    - source: salt://app-debug/php-fpm/platform.debug.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
    - user: root
    - group: root
    - mode: 0644
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - app-debug.php-fpm.reload
{% endif %}
{% endfor %}

{% if pillar['systemd']['apply'] %}
app-debug.php-fpm.reload:
  cmd.run:
    - name: systemctl reload php{{ php.version }}-fpm || systemctl restart php{{ php.version }}-fpm
{% endif %}

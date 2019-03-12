#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% from 'php/map.jinja' import php with context %}

{% macro app_platform(app, domain) %}
{% set platform = salt['pillar.get']('platforms:' + domain) %}

{% if platform['php']['values']['session.save_path'] %}
app.{{ domain }}.php.session_save_path:
  file.directory:
    - name: {{ platform['php']['values']['session.save_path'] }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - makedirs: True
    - require:
      - user: {{ platform['user']['name'] }}
{% endif %}

app.{{ domain }}.user:
  user.present:
    - name: {{ platform['user']['name'] }}
    - fullname: {{ domain }}
    - shell: /bin/bash
    - home: {{ platform['user']['home'] }}

app.{{ domain }}.home:
  file.directory:
    - name: {{ platform['user']['home'] }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - user: {{ platform['user']['name'] }}

app.{{ domain }}.releases:
  file.directory:
    - name: {{ platform['user']['home'] }}/releases
    - makedirs: True
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: app.{{ domain }}.home

app.{{ domain }}.php-fpm.log:
  file.directory:
    - name: /var/log/php{{ php.version }}-fpm/{{ platform['basename'] }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0750

{% for instance in ['blue', 'green'] %}
app.{{ domain }}.{{ instance }}.php-fpm:
  file.managed:
    - name: /etc/php/{{ php.version }}/fpm/pools-available/{{ platform['basename'] }}.{{ instance }}.conf
    - source: salt://php/php-fpm/platform.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
      instance: {{ instance }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: php.pkgs
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: app-{{ app }}.php-fpm.reload
{% endif %}
{% endfor %}
{% endmacro %}

{% macro app_restarts(app) %}
app-{{ app }}.php-fpm.reload:
{% if pillar['systemd']['apply'] %}
  cmd.run:
    - name: systemctl reload php{{ php.version }}-fpm || systemctl restart php{{ php.version }}-fpm
{% else %}
  test.succeed_without_changes: []
{% endif %}
{% endmacro %}

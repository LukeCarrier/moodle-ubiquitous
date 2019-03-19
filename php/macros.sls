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
    - name: /var/log/php{{ platform.php.version }}-fpm/{{ platform['basename'] }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0750

{% for instance in ['blue', 'green'] %}
app.{{ domain }}.{{ instance }}.php-fpm:
  file.managed:
    - name: /etc/php/{{ platform.php.version }}/fpm/pools-available/{{ platform['basename'] }}.{{ instance }}.conf
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
      - service: app-{{ app }}.{{ platform.php.version }}.php.fpm.reload
{% endif %}
{% endfor %}
{% endmacro %}

{% macro app_restarts(app) %}
  {% for version in php.versions.keys() %}
app-{{ app }}.{{ version }}.php.fpm.reload:
    {% if pillar['systemd']['apply'] %}
  cmd.run:
    - name: systemctl reload php{{ version }}-fpm || systemctl restart php{{ version }}-fpm
    {% else %}
  test.succeed_without_changes: []
    {% endif %}
  {% endfor %}
{% endmacro %}

{% macro php_pecl_extension(php_version, extension) %}
{% set php_ext_api_version = php.versions[php_version].extension_api_version %}
php.{{ php_version }}.pecl-ext.{{ extension }}:
  cmd.run:
    - name: |
        pecl \
            -d php_bin=/usr/bin/php{{ php_version }} \
            -d php_dir=/usr/share/php/{{ php_version }} \
            -d doc_dir=/usr/share/php/{{ php_version }}/docs \
            -d data_dir=/usr/share/php/{{ php_version }}/data \
            -d test_dir=/usr/share/php/{{ php_version }}/tests \
            -d www_dir=/usr/share/php/{{ php_version }}/www \
            -d ext_dir=/usr/lib/php/{{ php_ext_api_version }} \
            -d php_suffix={{ php_version }} \
            install {{ extension }}
    - env:
      - PHP_PEAR_METADATA_DIR: /usr/share/php{{ php_version }}
    - unless: test -f /usr/lib/php/{{ php_ext_api_version }}/{{ extension }}.so
{% endmacro %}

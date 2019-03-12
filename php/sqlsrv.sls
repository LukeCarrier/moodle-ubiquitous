{% from 'php/map.jinja' import php with context %}

include:
  - php

php.sqlsrv.repo:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/mssql-release.list
    - humanname:
    - name: deb [arch=amd64] https://packages.microsoft.com/ubuntu/{{ grains['lsb_distrib_release'] }}/prod {{ grains['lsb_distrib_codename'] }} main
    - key_url: https://packages.microsoft.com/keys/microsoft.asc

{% for pkg, settings in php.sqlsrv.debconf.items() %}
php.sqlsrv.{{ pkg }}.debconf:
  debconf.set:
    - name: {{ pkg }}
    - data:
  {% for name, setting in settings.items() %}
        {{ name }}:
          type: {{ setting.type }}
          value: {{ setting.value }}
  {% endfor %}
{% endfor %}
php.sqlsrv.deps:
  pkg.latest:
    - pkgs:
      - build-essential
      - gcc
      - g++
      - unixodbc-dev
    - require:
      - pkgrepo: php.sqlsrv.repo

# Temporarily work around ODBC client packaging failing to check the debconf
# database and requiring ACCEPT_EULA environment variable to be set at install
# time.
#
# See https://connect.microsoft.com/SQLServer/Feedback/Details/3105172
php.sqlsrv.pkgs:
  cmd.run:
    - name: apt-get install --assume-yes {{ php.sqlsrv.pkgs | join(' ') }}
    - env:
      - ACCEPT_EULA: Y
    - unless: [ $(dpkg -l | grep -E '\b({{ php.sqlsrv.pkgs | join('|') }})\b' | wc -l) -eq {{ php.sqlsrv.pkgs | length }} ]
    - require:
      - pkg: php.sqlsrv.deps

{% for extension, priority in {'sqlsrv': 20, 'pdo_sqlsrv': 20}.items() %}
php.sqlsrv.{{ extension }}.pecl:
  pecl.installed:
    - name: {{ extension }}

php.sqlsrv.{{ extension }}.ini.available:
  file.managed:
    - name: /etc/php/{{ php.version }}/mods-available/{{ extension }}.ini
    - source: salt://php/php/extension.ini.jinja
    - template: jinja
    - context:
      extension: {{ extension }}
      priority: {{ priority }}

{% for sapi in ['cli', 'fpm'] %}
php.sqlsrv.{{ extension }}.ini.enabled.{{ sapi }}:
  file.symlink:
    - name: /etc/php/{{ php.version }}/{{ sapi }}/conf.d/{{ priority }}-{{ extension }}.ini
    - target: /etc/php/{{ php.version }}/mods-available/{{ extension }}.ini
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: php.fpm.restart
{% endif %}
{% endfor %}
{% endfor %}

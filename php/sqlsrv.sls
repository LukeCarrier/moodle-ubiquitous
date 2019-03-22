{% from 'php/map.jinja' import php with context %}
{% from 'php/macros.sls' import php_pecl_extension, php_extension_available, php_extension_enabled %}

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
    - name: apt-get install --assume-yes {{ php.sqlsrv.packages | join(' ') }}
    - env:
      - ACCEPT_EULA: Y
    - unless: [ $(dpkg -l | grep -E '\b({{ php.sqlsrv.packages | join('|') }})\b' | wc -l) -eq {{ php.sqlsrv.packages | length }} ]
    - require:
      - pkg: php.sqlsrv.deps

{% for version in php.versions.keys() %}
  {% for extension in ['sqlsrv', 'pdo_sqlsrv'] %}
{{ php_pecl_extension(version, extension) }}
{{ php_extension_available(version, extension, 20) }}
    {% for sapi in ['cli', 'fpm'] %}
{{ php_extension_enabled(version, sapi, extension, 20) }}
      {% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: php.{{ version }}.fpm.restart
      {% endif %}
    {% endfor %}
  {% endfor %}
{% endfor %}

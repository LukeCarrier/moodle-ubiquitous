#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - base
  - nginx-base

#
# nginx
#

/etc/logrotate.d/nginx:
  file.managed:
    - source: salt://app-base/logrotate/nginx
    - user: root
    - group: root
    - mode: 0644

/etc/nginx/sites-extra:
  file.directory:
    - user: root
    - group: root
    - mode: 755

#
# PHP
#

php.packages:
  pkg.installed:
    - pkgs:
      - php7.0-dev
      - php7.0-cli
      - php7.0-curl
      - php7.0-fpm
      - php7.0-gd
      - php7.0-gmp
      - php7.0-intl
      - php7.0-json
      - php7.0-mbstring
      - php7.0-mcrypt
      - php7.0-opcache
      - php7.0-pgsql
      - php7.0-soap
      - php7.0-xml
      - php7.0-xmlrpc
      - php7.0-zip

/etc/php/7.0/fpm/php-fpm.conf:
  file.managed:
    - source: salt://app-base/php-fpm/php-fpm.conf
    - user: root
    - group: root
    - mode: 0644

/etc/php/7.0/fpm/pools-available:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/etc/php/7.0/fpm/pools-enabled:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/etc/php/7.0/fpm/pools-extra:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/etc/php/7.0/fpm/pool.d:
  file.absent:
    - require:
      - pkg: php.packages
      - file: /etc/php/7.0/fpm/php-fpm.conf

/etc/php/7.0/fpm/pools-available/__default__.conf:
  file.managed:
    - source: salt://app-base/php-fpm/__default__.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: php.packages
      - file: /etc/php/7.0/fpm/pools-available

/etc/php/7.0/fpm/pools-enabled/__default__.conf:
  file.symlink:
    - target: /etc/php/7.0/fpm/pools-available/__default__.conf
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: php.packages
      - file: /etc/php/7.0/fpm/pools-enabled
      - file: /etc/php/7.0/fpm/pools-available/__default__.conf

/var/run/php:
  file.directory:
    - user: {{ pillar['nginx']['user'] }}
    - group: {{ pillar['nginx']['user'] }}
    - mode: 0750

/var/log/php7.0-fpm:
  file.directory:
    - user: root
    - group: root
    - mode: 0755

/etc/logrotate.d/php7.0-fpm:
  file.managed:
    - source: salt://app-base/logrotate/php7.0-fpm
    - user: root
    - group: root
    - mode: 0644

app-base.php-fpm.enable:
  service.running:
    - name: php7.0-fpm
    - enable: True
    - require:
      - php.packages
      - /etc/php/7.0/fpm/php-fpm.conf
      - /etc/php/7.0/fpm/pools-available
      - /etc/php/7.0/fpm/pools-enabled
      - /etc/php/7.0/fpm/pools-extra
      - /etc/php/7.0/fpm/pool.d
      - /etc/php/7.0/fpm/pools-available/__default__.conf
      - /etc/php/7.0/fpm/pools-enabled/__default__.conf
      - /var/run/php
      - /var/log/php7.0-fpm
      - /etc/logrotate.d/php7.0-fpm

#
# SQL Server drivers for PHP
#

php.sqlsrv.repo:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/mssql-release.list
    - humanname:
    - name: deb [arch=amd64] https://packages.microsoft.com/ubuntu/16.04/prod xenial main
    - key_url: https://packages.microsoft.com/keys/microsoft.asc

php.sqlsrv.msodbcsql.license:
  debconf.set:
    - name: 'msodbcsql'
    - data:
        'msodbcsql/accept_eula': { 'type': 'boolean', 'value': True }

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
    - name: apt-get install --assume-yes msodbcsql
    - env:
      - ACCEPT_EULA: Y
    - unless: dpkg -l | grep msodbcsql
    - require:
      - pkg: php.sqlsrv.deps

{% for extension, priority in {'sqlsrv': 20, 'pdo_sqlsrv': 20}.items() %}
php.sqlsrv.{{ extension }}.pecl:
  pecl.installed:
    - name: {{ extension }}

php.sqlsrv.{{ extension }}.ini.available:
  file.managed:
    - name: /etc/php/7.0/mods-available/{{ extension }}.ini
    - source: salt://app-base/php/extension.ini.jinja
    - template: jinja
    - context:
      extension: {{ extension }}
      priority: {{ priority }}

{% for sapi in ['cli', 'fpm'] %}
php.sqlsrv.{{ extension }}.ini.enabled.{{ sapi }}:
  file.symlink:
    - name: /etc/php/7.0/{{ sapi }}/conf.d/{{ priority }}-{{ extension }}.ini
    - target: /etc/php/7.0/mods-available/{{ extension }}.ini
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: app-base.php-fpm.restart
{% endif %}
{% endfor %}
{% endfor %}

#
# Directories
#

{% for home_directory in pillar['system']['home_directories'] %}
app-base.homes.{{ home_directory }}:
  file.directory:
    - name: {{ home_directory }}
    - user: root
    - group: root
    - mode: 755

{% if pillar['acl']['apply'] %}
app-base.homes.{{ home_directory }}.acl:
  acl.present:
    - name: {{ home_directory }}
    - acl_type: user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: app-base.homes.{{ home_directory }}
{% endif %}
{% endfor %}

app-base.php-fpm.restart:
  cmd.run:
    - name: systemctl restart php7.0-fpm

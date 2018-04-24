#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

app.php.packages:
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

app.php-fpm.php-fpm.conf:
  file.managed:
    - name: /etc/php/7.0/fpm/php-fpm.conf
    - source: salt://app-base/php-fpm/php-fpm.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

app.php-fpm.pools-available:
  file.directory:
    - name: /etc/php/7.0/fpm/pools-available
    - user: root
    - group: root
    - mode: 755

app.php-fpm.pools-enabled:
  file.directory:
    - name: /etc/php/7.0/fpm/pools-enabled
    - user: root
    - group: root
    - mode: 755

app.php-fpm.pools-extra:
  file.directory:
    - name: /etc/php/7.0/fpm/pools-extra
    - user: root
    - group: root
    - mode: 755

app.php-fpm.pool.d:
  file.absent:
    - name: /etc/php/7.0/fpm/pool.d
    - require:
      - pkg: app.php.packages
      - file: app.php-fpm.php-fpm.conf

app.php-fpm.pools-available.__default__:
  file.managed:
    - name: /etc/php/7.0/fpm/pools-available/__default__.conf
    - source: salt://app-base/php-fpm/__default__.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: app.php.packages

app.php-fpm.pools-enabled.__default__:
  file.symlink:
    - name: /etc/php/7.0/fpm/pools-enabled/__default__.conf
    - target: /etc/php/7.0/fpm/pools-available/__default__.conf
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: app.php.packages
      - file: app.php-fpm.pools-enabled
      - file: app.php-fpm.pools-available.__default__

app.php-fpm.run:
  file.directory:
    - name: /var/run/php
    - user: {{ pillar['nginx']['user'] }}
    - group: {{ pillar['nginx']['user'] }}
    - mode: 0750

app.php-fpm.log:
  file.directory:
    - name: /var/log/php7.0-fpm
    - user: root
    - group: root
    - mode: 0755

{% for acl in salt['pillar.get']('php:fpm:log_acl', []) %}
app.php-fpm.log.acl:
  acl.present:
    - name: /var/log/php7.0-fpm
    - acl_type: {{ acl['acl_type'] }}
    - acl_name: {{ acl['acl_name'] }}
    - perms: {{ acl['perms'] }}
    - recurse: True
{% endfor %}

app.php-fpm.logrotate:
  file.managed:
    - name: /etc/logrotate.d/php7.0-fpm
    - source: salt://app-base/logrotate/php7.0-fpm.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

{% if pillar['systemd']['apply'] %}
app.php-fpm.enable:
  service.running:
    - name: php7.0-fpm
    - enable: True
    - require:
      - pkg: app.php.packages
      - file: app.php-fpm.php-fpm.conf
      - file: app.php-fpm.pools-available
      - file: app.php-fpm.pools-enabled
      - file: app.php-fpm.pools-extra
      - file: app.php-fpm.pool.d
      - file: app.php-fpm.pools-available.__default__
      - file: app.php-fpm.pools-enabled.__default__
      - file: app.php-fpm.run
      - file: app.php-fpm.log
      - file: app.php-fpm.logrotate
{% endif %}

app.php.sqlsrv.repo:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/mssql-release.list
    - humanname:
    - name: deb [arch=amd64] https://packages.microsoft.com/ubuntu/16.04/prod xenial main
    - key_url: https://packages.microsoft.com/keys/microsoft.asc

app.php.sqlsrv.msodbcsql.license:
  debconf.set:
    - name: 'msodbcsql'
    - data:
        'msodbcsql/accept_eula': { 'type': 'boolean', 'value': True }

app.php.sqlsrv.deps:
  pkg.latest:
    - pkgs:
      - build-essential
      - gcc
      - g++
      - unixodbc-dev
    - require:
      - pkgrepo: app.php.sqlsrv.repo
      - debconf: app.php.sqlsrv.msodbcsql.license

# Temporarily work around ODBC client packaging failing to check the debconf
# database and requiring ACCEPT_EULA environment variable to be set at install
# time.
#
# See https://connect.microsoft.com/SQLServer/Feedback/Details/3105172
app.php.sqlsrv.pkgs:
  cmd.run:
    - name: apt-get install --assume-yes msodbcsql
    - env:
      - ACCEPT_EULA: Y
    - unless: dpkg -l | grep msodbcsql
    - require:
      - pkg: app.php.sqlsrv.deps

{% for extension, priority in {'sqlsrv': 20, 'pdo_sqlsrv': 20}.items() %}
app.php.sqlsrv.{{ extension }}.pecl:
  pecl.installed:
    - name: {{ extension }}

app.php.sqlsrv.{{ extension }}.ini.available:
  file.managed:
    - name: /etc/php/7.0/mods-available/{{ extension }}.ini
    - source: salt://app-base/php/extension.ini.jinja
    - template: jinja
    - context:
      extension: {{ extension }}
      priority: {{ priority }}

{% for sapi in ['cli', 'fpm'] %}
app.php.sqlsrv.{{ extension }}.ini.enabled.{{ sapi }}:
  file.symlink:
    - name: /etc/php/7.0/{{ sapi }}/conf.d/{{ priority }}-{{ extension }}.ini
    - target: /etc/php/7.0/mods-available/{{ extension }}.ini
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: app.php-fpm.restart
{% endif %}
{% endfor %}
{% endfor %}

{% for home_directory in pillar['system']['home_directories'] %}
app.homes.{{ home_directory }}:
  file.directory:
    - name: {{ home_directory }}
    - user: root
    - group: root
    - mode: 755

{% if pillar['acl']['apply'] %}
app.homes.{{ home_directory }}.acl:
  acl.present:
    - name: {{ home_directory }}
    - acl_type: user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: app.homes.{{ home_directory }}
{% endif %}
{% endfor %}

{% if pillar['systemd']['apply'] %}
app.php-fpm.restart:
  cmd.run:
    - name: systemctl restart php7.0-fpm
{% endif %}

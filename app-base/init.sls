#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
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

{% if pillar['iptables']['apply'] %}
nginx.iptables.http:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - proto: tcp
    - dport: 80
    - save: True
    - require:
      - iptables: iptables.default.input.established
    - require_in:
      - iptables: iptables.default.input.drop

nginx.iptables.https:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - proto: tcp
    - dport: 443
    - save: True
    - require:
      - iptables: iptables.default.input.established
    - require_in:
      - iptables: iptables.default.input.drop
{% endif %}

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
      - php7.0-intl
      - php7.0-json
      - php7.0-mbstring
      - php7.0-mcrypt
      - php7.0-opcache
      - php7.0-pdo
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
      - file: /etc/php/7.0/fpm/pools-enabled

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
      - service: app.php-fpm.restart
{% endif %}
{% endfor %}
{% endfor %}

#
# Supporting packages
#

moodle.dependencies:
  pkg.installed:
    - pkgs:
      - ghostscript
      - unoconv

#
# Required directories
#

{% for home_directory in pillar['system']['home_directories'] %}
homes.{{ home_directory }}:
  file.directory:
    - name: {{ home_directory }}
    - user: root
    - group: root
    - mode: 755

{% if pillar['acl']['apply'] %}
homes.{{ home_directory }}.acl:
  acl.present:
    - name: {{ home_directory }}
    - acl_type: user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: moodle.{{ domain }}.home
{% endif %}

app.{{ domain }}.releases:
  file.directory:
    - name: {{ platform['user']['home'] }}/releases
    - makedirs: True
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: app.{{ domain }}.home

{% if pillar['acl']['apply'] %}
app.{{ domain }}.releases.acl:
  acl.present:
    - name: {{ platform['user']['home'] }}/releases
    - acl_type: user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: app.{{ domain }}.releases

app.{{ domain }}.releases.acl.default:
  acl.present:
    - name: {{ platform['user']['home'] }}/releases
    - acl_type: default:user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: app.{{ domain }}.home
{% endif %}

app.{{ domain }}.data:
  file.directory:
    - name: {{ platform['user']['home'] }}/data
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: app.{{ domain }}.home

app.{{ domain }}.localcache:
  file.directory:
    - name: {{ platform['user']['home'] }}/data/localcache
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: app.{{ domain }}.data

app.{{ domain }}.nginx.log:
  file.directory:
    - name: /var/log/nginx/{{ platform['basename'] }}
    - user: www-data
    - group: adm
    - mode: 0750

app.{{ domain }}.nginx.available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - source: salt://app/nginx/platform.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
      instance: blue
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - app.nginx.restart
{% endif %}

app.{{ domain }}.nginx.enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ platform['basename'] }}.conf
    - target: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - require:
      - file: app.{{ domain }}.nginx.available
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - app.nginx.restart
{% endif %}

{% for name, contents in platform['nginx'].get('extra', {}).items() %}
app.{{ domain }}.nginx.extra.{{ name }}:
  file.managed:
    - name: /etc/nginx/sites-extra/{{ platform['basename'] }}.{{ name }}.conf
    - contents: {{ contents | yaml_encode }}
    - user: root
    - group: root
    - mode: 0644
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - app.nginx.reload
{% endif %}
{% endfor %}

app.{{ domain }}.php-fpm.log:
  file.directory:
    - name: /var/log/php7.0-fpm/{{ platform['basename'] }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0750

{% for instance in ['blue', 'green'] %}
app.{{ domain }}.{{ instance }}.php-fpm:
  file.managed:
    - name: /etc/php/7.0/fpm/pools-available/{{ platform['basename'] }}.{{ instance }}.conf
    - source: salt://app/php-fpm/platform.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
      instance: blue
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: php.packages
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - app.php-fpm.reload
{% endif %}
{% endfor %}

{% if pillar['systemd']['apply'] %}
app.nginx.reload:
  cmd.run:
    - name: systemctl reload nginx || systemctl restart nginx

app.nginx.restart:
  cmd.run:
    - name: systemctl restart nginx

app.php-fpm.enable:
  service.running:
    - name: php7.0-fpm
    - enable: True
    - require:
      - php.packages

app.php-fpm.reload:
  cmd.run:
    - name: systemctl reload php7.0-fpm || systemctl restart php7.0-fpm
    - require:
      - php.packages

app.php-fpm.restart:
  cmd.run:
    - name: systemctl restart php7.0-fpm
    - require:
      - php.packages
{% endif %}

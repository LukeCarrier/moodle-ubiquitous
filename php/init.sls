#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% from 'php/map.jinja' import php with context %}

php.pkgs:
  pkg.installed:
    - pkgs: {{ php.packages | yaml }}

php.fpm.php-fpm.conf:
  file.managed:
    - name: /etc/php/{{ php.version }}/fpm/php-fpm.conf
    - source: salt://php/php-fpm/php-fpm.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

php.fpm.pools-available:
  file.directory:
    - name: /etc/php/{{ php.version }}/fpm/pools-available
    - user: root
    - group: root
    - mode: 755

php.fpm.pools-enabled:
  file.directory:
    - name: /etc/php/{{ php.version }}/fpm/pools-enabled
    - user: root
    - group: root
    - mode: 755

php.fpm.pools-extra:
  file.directory:
    - name: /etc/php/{{ php.version }}/fpm/pools-extra
    - user: root
    - group: root
    - mode: 755

php.fpm.pool.d:
  file.absent:
    - name: /etc/php/{{ php.version }}/fpm/pool.d
    - require:
      - pkg: php.pkgs
      - file: php.fpm.php-fpm.conf

php.fpm.pools-available.__default__:
  file.managed:
    - name: /etc/php/{{ php.version }}/fpm/pools-available/__default__.conf
    - source: salt://php/php-fpm/__default__.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: php.pkgs

php.fpm.pools-enabled.__default__:
  file.symlink:
    - name: /etc/php/{{ php.version }}/fpm/pools-enabled/__default__.conf
    - target: /etc/php/{{ php.version }}/fpm/pools-available/__default__.conf
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: php.pkgs
      - file: php.fpm.pools-enabled
      - file: php.fpm.pools-available.__default__

php.fpm.run:
  file.directory:
    - name: /var/run/php
    - user: {{ salt['pillar.get']('php:fpm:socket_owner', 'www-data') }}
    - group: {{ salt['pillar.get']('php:fpm:socket_owner', 'www-data') }}
    - mode: 0750

php.fpm.log:
  file.directory:
    - name: /var/log/php{{ php.version }}-fpm
    - user: root
    - group: root
    - mode: 0755

{% for acl in salt['pillar.get']('php:fpm:log_acl', []) %}
php.fpm.log.acl:
  acl.present:
    - name: /var/log/php{{ php.version }}-fpm
    - acl_type: {{ acl['acl_type'] }}
    - acl_name: {{ acl['acl_name'] }}
    - perms: {{ acl['perms'] }}
    - recurse: True
{% endfor %}

php.fpm.logrotate:
  file.managed:
    - name: /etc/logrotate.d/php{{ php.version }}-fpm
    - source: salt://php/logrotate/php-fpm.jinja
    - template: jinja
    - context:
      php: {{ php | yaml }}
    - user: root
    - group: root
    - mode: 0644

{% if pillar['systemd']['apply'] %}
php.fpm.enable:
  service.running:
    - name: php{{ php.version }}-fpm
    - enable: True
    - require:
      - pkg: php.pkgs
      - file: php.fpm.php-fpm.conf
      - file: php.fpm.pools-available
      - file: php.fpm.pools-enabled
      - file: php.fpm.pools-extra
      - file: php.fpm.pool.d
      - file: php.fpm.pools-available.__default__
      - file: php.fpm.pools-enabled.__default__
      - file: php.fpm.run
      - file: php.fpm.log
      - file: php.fpm.logrotate
{% endif %}

{% if pillar['systemd']['apply'] %}
php.fpm.restart:
  cmd.run:
    - name: systemctl restart php{{ php.version }}-fpm
{% endif %}

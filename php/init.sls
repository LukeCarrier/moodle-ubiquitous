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

# FIXME: systemd should manage this with RuntimeDirectory
#        paths will need to change to being per-release though
php.fpm.run:
  file.directory:
    - name: /var/run/php
    - user: {{ salt['pillar.get']('php:fpm:socket_owner', 'www-data') }}
    - group: {{ salt['pillar.get']('php:fpm:socket_owner', 'www-data') }}
    - mode: 0750

{% for version, config in php.versions.items() %}
php.{{ version }}.fpm.php-fpm.conf:
  file.managed:
    - name: /etc/php/{{ version }}/fpm/php-fpm.conf
    - source: salt://php/php-fpm/php-fpm.conf.jinja
    - template: jinja
    - context:
      config: {{ config | yaml }}
      version: {{ version }}
    - user: root
    - group: root
    - mode: 0644

php.{{ version }}.fpm.pools-available:
  file.directory:
    - name: /etc/php/{{ version }}/fpm/pools-available
    - user: root
    - group: root
    - mode: 755

php.{{ version }}.fpm.pools-enabled:
  file.directory:
    - name: /etc/php/{{ version }}/fpm/pools-enabled
    - user: root
    - group: root
    - mode: 755

php.{{ version }}.fpm.pools-extra:
  file.directory:
    - name: /etc/php/{{ version }}/fpm/pools-extra
    - user: root
    - group: root
    - mode: 755

php.{{ version }}.fpm.pool.d:
  file.absent:
    - name: /etc/php/{{ version }}/fpm/pool.d
    - require:
      - pkg: php.pkgs
      - file: php.{{ version }}.fpm.php-fpm.conf

php.{{ version }}.fpm.pools-available.__default__:
  file.managed:
    - name: /etc/php/{{ version }}/fpm/pools-available/__default__.conf
    - source: salt://php/php-fpm/__default__.conf.jinja
    - template: jinja
    - context:
      version: {{ version }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: php.pkgs

php.{{ version }}.fpm.pools-enabled.__default__:
  file.symlink:
    - name: /etc/php/{{ version }}/fpm/pools-enabled/__default__.conf
    - target: /etc/php/{{ version }}/fpm/pools-available/__default__.conf
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: php.pkgs
      - file: php.{{ version }}.fpm.pools-enabled
      - file: php.{{ version }}.fpm.pools-available.__default__

php.{{ version }}.fpm.log:
  file.directory:
    - name: /var/log/php{{ version }}-fpm
    - user: root
    - group: root
    - mode: 0755

  {% for acl in config.fpm.get('log_acl', []) %}
php.{{ version }}.fpm.log.acl:
  acl.present:
    - name: /var/log/php{{ version }}-fpm
    - acl_type: {{ acl['acl_type'] }}
    - acl_name: {{ acl['acl_name'] }}
    - perms: {{ acl['perms'] }}
    - recurse: True
  {% endfor %}

php.{{ version }}.fpm.logrotate:
  file.managed:
    - name: /etc/logrotate.d/php{{ version }}-fpm
    - source: salt://php/logrotate/php-fpm.jinja
    - template: jinja
    - context:
      version: {{ version }}
      config: {{ config | yaml }}
    - user: root
    - group: root
    - mode: 0644

  {% if pillar['systemd']['apply'] %}
php.{{ version }}.fpm.enable:
  service.running:
    - name: php{{ version }}-fpm
    - enable: True
    - require:
      - pkg: php.pkgs
      - file: php.fpm.run
      - file: php.{{ version }}.fpm.php-fpm.conf
      - file: php.{{ version }}.fpm.pools-available
      - file: php.{{ version }}.fpm.pools-enabled
      - file: php.{{ version }}.fpm.pools-extra
      - file: php.{{ version }}.fpm.pool.d
      - file: php.{{ version }}.fpm.pools-available.__default__
      - file: php.{{ version }}.fpm.pools-enabled.__default__
      - file: php.{{ version }}.fpm.log
      - file: php.{{ version }}.fpm.logrotate

php.{{ version }}.fpm.restart:
  cmd.run:
    - name: systemctl restart php{{ version }}-fpm
  {% endif %}
{% endfor %}

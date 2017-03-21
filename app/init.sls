#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - base

#
# nginx
#

nginx:
  pkg.installed: []
  service.running:
    - enable: True
    - require:
      - pkg: nginx

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

nginx.reload:
  service.running:
    - name: nginx
    - reload: True

/etc/nginx/sites-enabled/default:
  file.absent:
    - require:
      - pkg: nginx

/etc/nginx/sites-available/default:
  file.absent:
    - require:
      - file: /etc/nginx/sites-enabled/default
      - pkg: nginx

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
    - source: salt://app/php-fpm/php-fpm.conf
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

php-fpm:
  service.running:
    - name: php7.0-fpm
    - enable: True
    - require:
      - pkg: nginx
      - pkg: php.packages

php-fpm.reload:
  service.running:
    - name: php7.0-fpm
    - reload: True

#
# Supporting packages
#

ghostscript:
  pkg.installed

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
  acl.present:
    - name: {{ home_directory }}
    - acl_type: user
    - acl_name: nginx
    - perms: rx
{% endfor %}

#
# Moodle platforms
#

{% for domain, platform in pillar['platforms'].items() %}
moodle.{{ domain }}.user:
  user.present:
    - name: {{ platform['user']['name'] }}
    - fullname: {{ domain }}
    - shell: /bin/bash
    - home: {{ platform['user']['home'] }}
    - gid_from_name: true

moodle.{{ domain }}.home:
  file.directory:
    - name: {{ platform['user']['home'] }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - user: {{ platform['user']['name'] }}
  acl.present:
    - name: {{ platform['user']['home'] }}
    - acl_type: user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: moodle.{{ domain }}.home

moodle.{{ domain }}.home.default:
  acl.present:
    - name: {{ platform['user']['home'] }}
    - acl_type: default:user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: moodle.{{ domain }}.home

moodle.{{ domain }}.releases:
  file.directory:
    - name: {{ platform['user']['home'] }}/releases
    - makedirs: True
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: moodle.{{ domain }}.home
  acl.present:
    - name: {{ platform['user']['home'] }}/releases
    - acl_type: user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: moodle.{{ domain }}.releases

moodle.{{ domain }}.releases.default:
  acl.present:
    - name: {{ platform['user']['home'] }}/releases
    - acl_type: default:user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: moodle.{{ domain }}.home

moodle.{{ domain }}.data:
  file.directory:
    - name: {{ platform['user']['home'] }}/data
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: moodle.{{ domain }}.home

moodle.{{ domain }}.nginx.available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - source: salt://app/nginx/platform.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
      instance: blue
      platform: {{ platform }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx

moodle.{{ domain }}.nginx.enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ platform['basename'] }}.conf
    - target: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - require:
      - file: moodle.{{ domain }}.nginx.available
    - require_in:
      - service: nginx.reload

{% for instance in ['blue', 'green'] %}
moodle.{{ domain }}.{{ instance }}.php-fpm:
  file.managed:
    - name: /etc/php/7.0/fpm/pools-available/{{ platform['basename'] }}.{{ instance }}.conf
    - source: salt://app/php-fpm/platform.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
      instance: blue
      platform: {{ platform }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: php.packages
    - require_in:
      - service: php-fpm.reload
{% endfor %}

moodle.{{ domain }}.config:
  file.managed:
    - name: {{ platform['user']['home'] }}/config.php
    - source: salt://app/moodle/config.php.jinja
    - template: jinja
    - context:
      cfg: {{ platform['moodle'] }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0660
{% endfor %}

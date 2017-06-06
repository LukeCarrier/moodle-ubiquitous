#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - base
  - app-base

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
{% endfor %}

moodle.{{ domain }}.releases:
  file.directory:
    - name: {{ platform['user']['home'] }}/releases
    - makedirs: True
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: moodle.{{ domain }}.home

{% if pillar['acl']['apply'] %}
moodle.{{ domain }}.releases.acl:
  acl.present:
    - name: {{ platform['user']['home'] }}/releases
    - acl_type: user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: moodle.{{ domain }}.releases

moodle.{{ domain }}.releases.acl.default:
  acl.present:
    - name: {{ platform['user']['home'] }}/releases
    - acl_type: default:user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: moodle.{{ domain }}.home
{% endif %}

moodle.{{ domain }}.data:
  file.directory:
    - name: {{ platform['user']['home'] }}/data
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: moodle.{{ domain }}.home

moodle.{{ domain }}.localcache:
  file.directory:
    - name: {{ platform['user']['home'] }}/data/localcache
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: moodle.{{ domain }}.data

moodle.{{ domain }}.nginx.log:
  file.directory:
    - name: /var/log/nginx/{{ platform['basename'] }}
    - user: www-data
    - group: adm
    - mode: 0750

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
{% if pillar['systemd']['apply'] %}
    - require_in:
      - service: nginx.reload
{% endif %}

moodle.{{ domain }}.nginx.enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ platform['basename'] }}.conf
    - target: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - require:
      - file: moodle.{{ domain }}.nginx.available
{% if pillar['systemd']['apply'] %}
    - require_in:
      - service: nginx.reload
{% endif %}

moodle.{{ domain }}.php-fpm.log:
  file.directory:
    - name: /var/log/php7.0-fpm/{{ platform['basename'] }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0750

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
{% if pillar['systemd']['apply'] %}
    - require_in:
      - service: php-fpm.reload
{% endif %}
{% endfor %}

#
# Moodle platforms
#

{% for domain, platform in salt['pillar.get']('platforms:moodle_platforms', {}).items() %}
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

{% if pillar['acl']['apply'] %}
moodle.{{ domain }}.home.acl:
  acl.present:
    - name: {{ platform['user']['home'] }}
    - acl_type: user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: moodle.{{ domain }}.home

moodle.{{ domain }}.home.acl.default:
  acl.present:
    - name: {{ platform['user']['home'] }}
    - acl_type: default:user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: moodle.{{ domain }}.home
{% endif %}

moodle.{{ domain }}.releases:
  file.directory:
    - name: {{ platform['user']['home'] }}/releases
    - makedirs: True
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: moodle.{{ domain }}.home

{% if pillar['acl']['apply'] %}
moodle.{{ domain }}.releases.acl:
  acl.present:
    - name: {{ platform['user']['home'] }}/releases
    - acl_type: user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: moodle.{{ domain }}.releases

moodle.{{ domain }}.releases.acl.default:
  acl.present:
    - name: {{ platform['user']['home'] }}/releases
    - acl_type: default:user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: moodle.{{ domain }}.home
{% endif %}

moodle.{{ domain }}.data:
  file.directory:
    - name: {{ platform['user']['home'] }}/data
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: moodle.{{ domain }}.home

moodle.{{ domain }}.nginx.log:
  file.directory:
    - name: /var/log/nginx/{{ platform['basename'] }}
    - user: www-data
    - group: adm
    - mode: 0640

moodle.{{ domain }}.nginx.available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - source: salt://app-moodle/nginx/platform.conf.jinja
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
{% if pillar['systemd']['apply'] %}
    - require_in:
      - service: nginx.reload
{% endif %}

moodle.{{ domain }}.php-fpm.log:
  file.directory:
    - name: /var/log/php7.0-fpm/{{ platform['basename'] }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0750

{% for instance in ['blue', 'green'] %}
moodle.{{ domain }}.{{ instance }}.php-fpm:
  file.managed:
    - name: /etc/php/7.0/fpm/pools-available/{{ platform['basename'] }}.{{ instance }}.conf
    - source: salt://app-base/php-fpm/platform.conf.jinja
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
{% if pillar['systemd']['apply'] %}
    - require_in:
      - service: php-fpm.reload
{% endif %}
{% endfor %}

moodle.{{ domain }}.config:
  file.managed:
    - name: {{ platform['user']['home'] }}/config.php
    - source: salt://app-moodle/moodle/config.php.jinja
    - template: jinja
    - context:
      cfg: {{ platform['moodle'] }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0660
{% endfor %}

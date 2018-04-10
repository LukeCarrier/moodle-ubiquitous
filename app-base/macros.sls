#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% macro app_platform(app, domain, platform) %}
{% if platform['php']['values']['session.save_path'] %}
app-base.{{ domain }}.php.session_save_path:
  file.directory:
    - name: {{ platform['php']['values']['session.save_path'] }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - makedirs: True
    - require:
      - user: {{ platform['user']['name'] }}
{% endif %}

app-base.{{ domain }}.user:
  user.present:
    - name: {{ platform['user']['name'] }}
    - fullname: {{ domain }}
    - shell: /bin/bash
    - home: {{ platform['user']['home'] }}

app-base.{{ domain }}.home:
  file.directory:
    - name: {{ platform['user']['home'] }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - user: {{ platform['user']['name'] }}

{% if pillar['acl']['apply'] %}
app-base.{{ domain }}.home.acl:
  acl.present:
    - name: {{ platform['user']['home'] }}
    - acl_type: user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: app-base.{{ domain }}.home

app-base.{{ domain }}.home.acl.default:
  acl.present:
    - name: {{ platform['user']['home'] }}
    - acl_type: default:user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: app-base.{{ domain }}.home
{% endif %}

app-base.{{ domain }}.releases:
  file.directory:
    - name: {{ platform['user']['home'] }}/releases
    - makedirs: True
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: app-base.{{ domain }}.home

{% if pillar['acl']['apply'] %}
app-base.{{ domain }}.releases.acl:
  acl.present:
    - name: {{ platform['user']['home'] }}/releases
    - acl_type: user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: app-base.{{ domain }}.releases

app-base.{{ domain }}.releases.acl.default:
  acl.present:
    - name: {{ platform['user']['home'] }}/releases
    - acl_type: default:user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: app-base.{{ domain }}.home
{% endif %}

app-base.{{ domain }}.nginx.log:
  file.directory:
    - name: /var/log/nginx/{{ platform['basename'] }}
    - user: www-data
    - group: adm
    - mode: 0750

{% for name, contents in platform['nginx'].get('extra', {}).items() %}
app-base.{{ domain }}.nginx.extra.{{ name }}:
  file.managed:
    - name: /etc/nginx/sites-extra/{{ platform['basename'] }}.{{ name }}.conf
    - contents: {{ contents | yaml_encode }}
    - user: root
    - group: root
    - mode: 0644
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - app-{{ app }}.nginx.reload
{% endif %}
{% endfor %}

app-base.{{ domain }}.php-fpm.log:
  file.directory:
    - name: /var/log/php7.0-fpm/{{ platform['basename'] }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0750

{% for instance in ['blue', 'green'] %}
app-base.{{ domain }}.{{ instance }}.php-fpm:
  file.managed:
    - name: /etc/php/7.0/fpm/pools-available/{{ platform['basename'] }}.{{ instance }}.conf
    - source: salt://app-base/php-fpm/platform.conf.jinja
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
      - service: app-{{ app }}.php-fpm.reload
{% endif %}
{% endfor %}
{% endmacro %}

{% macro app_restarts(app) %}
app-{{ app }}.php-fpm.reload:
  cmd.run:
    - name: systemctl reload php7.0-fpm || systemctl restart php7.0-fpm

app-{{ app }}.nginx.reload:
  cmd.run:
    - name: systemctl reload nginx || systemctl restart nginx

app-{{ app }}.nginx.restart:
  cmd.run:
    - name: systemctl restart nginx
{% endmacro %}

{% macro php_fpm_status_clients(platform_basename) %}
location ~ ^/(status|ping)$ {
{% for client in salt['pillar.get']('php-fpm:status_clients', []) %}
    allow {{ client }};
{% endfor %}
    deny all;

    include fastcgi.conf;
    fastcgi_pass unix:/var/run/php/php7.0-fpm-{{ platform_basename }}.sock;
}
{% endmacro %}

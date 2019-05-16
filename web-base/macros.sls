#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% macro web_platform(app, domain, platform) %}
web.{{ domain }}.user:
  user.present:
    - name: {{ platform['user']['name'] }}
    - fullname: {{ domain }}
    - shell: /bin/bash
    - home: {{ platform['user']['home'] }}

web.{{ domain }}.home:
  file.directory:
    - name: {{ platform['user']['home'] }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - user: web.{{ domain }}.user

web.{{ domain }}.releases:
  file.directory:
    - name: {{ platform['user']['home'] }}/releases
    - makedirs: True
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - mode: 0770
    - require:
      - file: web.{{ domain }}.home

web.{{ domain }}.nginx.log:
  file.directory:
    - name: /var/log/nginx/{{ platform['basename'] }}
    - user: www-data
    - group: adm
    - mode: 0750
    - require:
      - pkg: nginx.pkgs

{% for name, contents in platform['nginx'].get('extra', {}).items() %}
web.{{ domain }}.nginx.extra.{{ name }}:
  file.managed:
    - name: /etc/nginx/sites-extra/{{ platform['basename'] }}.{{ name }}.conf
    - contents: {{ contents | yaml_encode }}
    - user: root
    - group: root
    - mode: 0644
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - web-{{ app }}.nginx.reload
{% endif %}
{% endfor %}

{% if pillar['acl']['apply'] %}
web.{{ domain }}.home.acl:
  acl.present:
    - name: {{ platform['user']['home'] }}
    - acl_type: user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: web.{{ domain }}.home
      - pkg: web.homes.acl

web.{{ domain }}.home.acl.default:
  acl.present:
    - name: {{ platform['user']['home'] }}
    - acl_type: default:user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: web.{{ domain }}.home

web.{{ domain }}.releases.acl:
  acl.present:
    - name: {{ platform['user']['home'] }}/releases
    - acl_type: user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: web.{{ domain }}.releases

web.{{ domain }}.releases.acl.default:
  acl.present:
    - name: {{ platform['user']['home'] }}/releases
    - acl_type: default:user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: web.{{ domain }}.home
{% endif %}
{% endmacro %}

{% macro php_fpm_status_clients(domain) %}
location ~ ^/(status|ping)$ {
{% for client in salt['pillar.get']('php-fpm:status_clients', []) %}
    allow {{ client }};
{% endfor %}
    deny all;

    include fastcgi.conf;
    fastcgi_pass {{ salt['pillar.get']('platforms:' + domain + ':nginx:fastcgi_pass') }};
}
{% endmacro %}

{% macro web_restarts(app) %}
web-{{ app }}.nginx.reload:
{% if pillar['systemd']['apply'] %}
  cmd.run:
    - name: systemctl reload nginx || systemctl restart nginx
{% else %}
  test.succeed_without_changes: []
{% endif %}

web-{{ app }}.nginx.restart:
{% if pillar['systemd']['apply'] %}
  cmd.run:
    - name: systemctl restart nginx
{% else %}
  test.succeed_without_changes: []
{% endif %}
{% endmacro %}

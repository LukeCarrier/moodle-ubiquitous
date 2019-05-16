#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% from "nginx/map.jinja" import nginx with context %}

nginx.pkgs:
  pkg.installed:
    - pkgs: {{ nginx.packages | yaml }}

nginx.conf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/nginx/nginx.conf.jinja
    - template: jinja
    - context:
      has_modules: {{ nginx.has_modules }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx.pkgs

nginx.default-enabled:
  file.absent:
    - name: /etc/nginx/sites-enabled/default
    - require:
      - pkg: nginx.pkgs

nginx.default-available:
  file.absent:
    - name: /etc/nginx/sites-available/default
    - require:
      - file: nginx.default-enabled
      - pkg: nginx.pkgs

nginx.log-formats:
  file.managed:
    - name: /etc/nginx/conf.d/log-formats.conf
    - source: salt://nginx/nginx/log-formats.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx.pkgs

nginx.ssl-params:
  file.managed:
    - name: /etc/nginx/ssl_params
    - source: salt://nginx/nginx/ssl_params
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx.pkgs

nginx.acme-challenge:
  file.managed:
  - name: /etc/nginx/snippets/acme-challenge.conf
  - source: salt://nginx/nginx/acme-challenge.conf
  - user: root
  - group: root
  - mode: 0644
  - require:
    - pkg: nginx.pkgs

{% for acl in salt['pillar.get']('nginx:log_acl', []) %}
nginx.log.acl:
  acl.present:
    - name: /var/log/nginx
    - acl_type: {{ acl['acl_type'] }}
    - acl_name: {{ acl['acl_name'] }}
    - perms: {{ acl['perms'] }}
    - recurse: True
{% endfor %}

nginx.logrotate:
  file.managed:
    - name: /etc/logrotate.d/nginx
    - source: salt://nginx/logrotate/nginx.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

{% if pillar['systemd']['apply'] %}
nginx.service:
  service.running:
    - name: nginx
    - enable: True
    - require:
      - pkg: nginx.pkgs

nginx.reload:
  cmd.run:
    - name: systemctl reload nginx || systemctl restart nginx
    - onchanges:
      - file: nginx.default-available
      - file: nginx.default-enabled
      - file: nginx.log-formats
      - file: nginx.ssl-params

nginx.restart:
  cmd.run:
    - name: systemctl restart nginx
    - onchanges:
      - file: nginx.conf
{% endif %}

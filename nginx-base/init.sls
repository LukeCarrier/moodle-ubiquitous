#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

nginx:
  pkg.installed:
    - pkgs:
      - nginx
      - nginx-extras

nginx.conf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx-base/nginx/nginx.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx

nginx.default-enabled:
  file.absent:
    - name: /etc/nginx/sites-enabled/default
    - require:
      - pkg: nginx

nginx.default-available:
  file.absent:
    - name: /etc/nginx/sites-available/default
    - require:
      - file: nginx.default-enabled
      - pkg: nginx

nginx.ssl-params:
  file.managed:
    - name: /etc/nginx/ssl_params
    - source: salt://nginx-base/nginx/ssl_params
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx

{% if pillar['systemd']['apply'] %}
nginx.service:
  service.running:
    - name: nginx
    - enable: True
    - require:
      - pkg: nginx

nginx.reload:
  service.running:
    - name: nginx
    - reload: True
    - watch:
      - file: nginx.conf
      - file: nginx.default-available
      - file: nginx.default-enabled
      - file: nginx.ssl-params
{% endif %}

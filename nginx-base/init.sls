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

nginx.log-formats:
  file.managed:
    - name: /etc/nginx/conf.d/log-formats.conf
    - source: salt://nginx-base/nginx/log-formats.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
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

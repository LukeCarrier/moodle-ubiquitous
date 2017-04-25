#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

nginx:
  pkg.installed: []

/etc/nginx/sites-enabled/default:
  file.absent:
    - require:
      - pkg: nginx

nginx.ssl_params:
  file.managed:
    - name: /etc/nginx/ssl_params
    - source: salt://nginx-base/nginx/ssl_params
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
{% endif %}

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

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx-base/nginx/nginx.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx

/etc/nginx/sites-available/default:
  file.absent:
    - require:
      - file: /etc/nginx/sites-enabled/default
      - pkg: nginx

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

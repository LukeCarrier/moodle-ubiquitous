#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - gocd-base
  - nginx-base

gocd-server.pkgs:
  pkg.installed:
  - name: go-server
  - require:
    - pkgrepo: gocd.repo
  - require_in:
    - file: gocd.ssh

{% if pillar['systemd']['apply'] %}
gocd-server.service:
  service.running:
  - name: go-server
  - enable: True
  - require:
    - pkg: gocd-server.pkgs
{% endif %}

gocd-server.users:
  file.managed:
    - name: /var/go/users
    - source: salt://gocd-server/gocd/users.jinja
    - template: jinja
    - user: go
    - group: go
    - mode: 0600
    - require:
      - pkg: gocd-server.pkgs

gocd-server.nginx.available:
  file.managed:
    - name: /etc/nginx/sites-available/gocd-server.conf
    - source: salt://gocd-server/nginx/gocd-server.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - file: nginx.acme-challenge
{% if pillar['systemd']['apply'] %}
    - watch_in:
      - service: nginx.reload
{% endif %}

gocd-server.nginx.enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/gocd-server.conf
    - target: /etc/nginx/sites-available/gocd-server.conf
    - require:
      - file: gocd-server.nginx.available
{% if pillar['systemd']['apply'] %}
    - require_in:
      - service: nginx.reload
{% endif %}

{% if salt['pillar.get']('gocd-server:nginx:server_name') %}
gocd-server.cert:
  acme.cert:
    - name: {{ pillar['gocd-server']['nginx']['server_name'] }}
    - email: {{ pillar['gocd-server']['acme']['email'] }}
    - webroot: /var/www/acme
    - renew: 45
    - require:
      - pkg: certbot.pkg
      - file: certbot.root
{% endif %}

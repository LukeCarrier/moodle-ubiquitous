#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - base
  - gocd-base
  - nginx-base

go-server:
  pkg.installed:
  - require:
    - file: /etc/apt/sources.list.d/gocd.list
    - cmd: /etc/apt/sources.list.d/gocd.list
  - require_in:
    - file: /var/go/.ssh

{% if pillar['systemd']['apply'] %}
go-server.service:
  service.running:
  - name: go-server
  - enable: True
  - require:
    - pkg: go-server
{% endif %}

{% if pillar['iptables']['apply'] %}
go-server.iptables.http:
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

go-server.iptables.https:
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
{% endif %}

/var/go/users:
  file.managed:
    - source: salt://gocd-server/gocd/users.jinja
    - template: jinja
    - user: go
    - group: go
    - mode: 0600
    - require:
      - pkg: go-server

/etc/nginx/sites-available/gocd-server.conf:
  file.managed:
    - source: salt://gocd-server/nginx/gocd-server.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
{% if pillar['systemd']['apply'] %}
    - watch_in:
      - service: nginx.reload
{% endif %}

/etc/nginx/sites-enabled/gocd-server.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/gocd-server.conf
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

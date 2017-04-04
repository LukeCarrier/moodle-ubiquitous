#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - base
  - gocd-base

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
go-server.iptables.dashboard-http:
  iptables.append:
  - chain: INPUT
  - jump: ACCEPT
  - proto: tcp
  - dport: 8153
  - save: True
  - require:
    - iptables: iptables.default.input.established
  - require_in:
    - iptables: iptables.default.input.drop

go-server.iptables.dashboard-https:
  iptables.append:
  - chain: INPUT
  - jump: ACCEPT
  - proto: tcp
  - dport: 8154
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

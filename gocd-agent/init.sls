#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - base
  - gocd-base

go-agent:
  pkg.installed:
    - require:
      - file: /etc/apt/sources.list.d/gocd.list
      - cmd: /etc/apt/sources.list.d/gocd.list
    - require_in:
      - file: /var/go/.ssh

{% if pillar['systemd']['apply'] %}
go-agent.service:
  service.running:
    - name: go-agent
    - enable: True
    - require:
      - pkg: go-agent
      - file: go-agent.defaults
{% endif %}

go-agent.defaults:
  file.managed:
    - name: /etc/default/go-agent
    - source: salt://gocd-agent/gocd/agent-defaults.jinja
    - template: jinja
    - user: root
    - group: go
    - mode: 0640
    - require:
      - pkg: go-agent

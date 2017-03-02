#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - base
  - gocd-base

go-agent:
  pkg.installed:
    - require:
      - file: /etc/apt/sources.list.d/gocd.list
      - cmd: /etc/apt/sources.list.d/gocd.list
  service.running:
    - enable: True
    - require:
      - pkg: go-agent
      - file: go-agent.defaults

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

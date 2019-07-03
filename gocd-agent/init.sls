#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - gocd-base

gocd-agent.pkgs:
  pkg.installed:
    - name: go-agent
    - require:
      - pkgrepo: gocd.repo
    - require_in:
      - file: /var/go/.ssh

gocd-agent.defaults:
  file.managed:
    - name: /etc/default/go-agent
    - source: salt://gocd-agent/gocd/agent-defaults.jinja
    - template: jinja
    - user: root
    - group: go
    - mode: 0640
    - require:
      - pkg: gocd-agent.pkgs

{% if pillar['systemd']['apply'] %}
gocd-agent.service:
  service.running:
    - name: go-agent
    - enable: True
    - require:
      - pkg: gocd-agent.pkgs
      - file: gocd-agent.defaults

gocd-agent.restart:
  cmd.run:
    - name: systemctl restart go-agent
    - onchanges:
      - file: gocd-agent.defaults
{% endif %}

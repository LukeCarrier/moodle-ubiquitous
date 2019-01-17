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
{% endif %}

{% if 'sudo_commands' in pillar['gocd-agent'] %}
gocd-agent.sudo.pkgs:
  pkg.installed:
    - name: sudo

gocd-agent.sudo.config:
  file.managed:
    - name: /etc/sudoers.d/gocd
    - source: salt://gocd-agent/sudo/gocd.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0440
    - require:
      - pkg: gocd-agent.sudo.pkgs
{% endif %}

#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% set conf_dir = '/etc/datadog-agent' %}
{% set additional_checksd = salt['pillar.get'](
    'datadog-agent:config:additional_checksd', conf_dir + '/checks.d') %}
{% set confd_path = salt['pillar.get'](
    'datadog-agent:config:confd_path', conf_dir + '/conf.d') %}

datadog-agent.repo:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/datadog.list
    - humanname: Datadog
    - name: deb https://apt.datadoghq.com/ stable 6
    - keyserver: hkp://pool.sks-keyservers.net:80
    - keyid: 382E94DE

datadog-agent.pkgs:
  pkg.latest:
    - name: datadog-agent
    - require:
      - pkgrepo: datadog-agent.repo

datadog-agent.datadog.yaml:
  file.serialize:
    - name: {{ conf_dir }}/datadog.yaml
    - formatter: yaml
    - dataset_pillar: datadog-agent:config
    - user: dd-agent
    - group: dd-agent
    - mode: 0640
    - require:
      - pkg: datadog-agent.pkgs

{% for name in salt['pillar.get']('datadog-agent:checks', {}).keys() %}
datadog-agent.checks.{{ name }}:
  file.managed:
    - name: {{ additional_checksd }}/{{ name }}
    - contents_pillar: datadog-agent:checks:{{ name }}
    - user: dd-agent
    - group: dd-agent
    - mode: 0755
    - require:
      - pkg: datadog-agent.pkgs
    - onchanges_in:
      - cmd: datadog-agent.restart
{% endfor %}

{% for integration_name, configs in salt['pillar.get']('datadog-agent:integrations', {}).items() %}
datadog-agent.integrations.{{ integration_name }}:
  file.directory:
    - name: {{ confd_path }}/{{ integration_name }}.d
    - user: dd-agent
    - group: dd-agent
    - mode: 0755
    - require:
      - pkg: datadog-agent.pkgs

{% for config_name in configs.keys() %}
datadog-agent.integrations.{{ integration_name }}.{{ config_name }}:
  file.serialize:
    - name: {{ confd_path }}/{{ integration_name }}.d/{{ config_name }}.yaml
    - formatter: yaml
    - dataset_pillar: datadog-agent:integrations:{{ integration_name }}:{{ config_name }}
    - user: dd-agent
    - group: dd-agent
    - mode: 0644
    - require:
      - file: datadog-agent.integrations.{{ integration_name }}
    - require_in:
      - service: datadog-agent.service
    - onchanges_in:
      - cmd: datadog-agent.restart
{% endfor %}
{% endfor %}

{% if salt['pillar.get']('datadog-agent:journald:grant_group_membership') %}
datadog-agent.journald.grant-group-membership:
  user.present:
    - name: dd-agent
    - groups:
      - systemd-journal
    - onchanges_in:
      - datadog-agent.restart
{% endif %}

{% if salt['pillar.get']('datadog-agent:postfix:grant_agent_find') %}
datadog-agent.postfix.grant-agent-find:
  file.managed:
    - name: /etc/sudoers.d/datadog-agent-postfix
    - source: salt://datadog-agent/sudo/postfix.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0440
{% endif %}

datadog-agent.service:
  service.running:
    - name: datadog-agent
    - enable: True

datadog-agent.restart:
  cmd.run:
    - name: systemctl restart datadog-agent
    - onchanges:
      - file: datadog-agent.datadog.yaml

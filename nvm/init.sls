#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% set user = salt['pillar.get']('nvm:user', 'root') %}
{% set group = salt['pillar.get']('nvm:group', 'root') %}
{% set home_dir = salt['pillar.get']('nvm:home_dir', '/root') %}

nvm.pkgs:
  pkg.latest:
    - pkgs:
      - curl

nvm.core:
  git.latest:
    - name: https://github.com/creationix/nvm.git
    - user: {{ user }}
    - target: {{ home_dir }}/.nvm
    - rev: master
    - force_checkout: True
    - force_reset: True
    - require:
      - pkg: nvm.pkgs

nvm.profile.script:
  file.managed:
    - name: {{ home_dir }}/.nvm.sh
    - source: salt://nvm/sh/nvm.sh.jinja
    - template: jinja
    - context:
      nvm_dir: {{ home_dir }}/.nvm
    - user: {{ user }}
    - group: {{ group }}
    - mode: 0640
    - require:
      - git: nvm.core

nvm.profile:
  file.blockreplace:
    - name: {{ home_dir }}/.profile
    - content: . "$HOME/.nvm.sh"
    - marker_start: '# start:nvm'
    - marker_end: '# end:nvm'
    - append_if_not_found: True
    - require:
      - file: nvm.profile.script

{% for version in salt['pillar.get']('nvm:node_versions', []) %}
nvm.node.{{ version }}:
  cmd.run:
    - name: . {{ home_dir }}/.nvm.sh && nvm install {{ version }}
    - unless: . {{ home_dir }}/.nvm.sh && nvm use {{ version }}
    - runas: {{ user }}
    - require:
      - file: nvm.profile
{% endfor %}

{% if salt['pillar.get']('nvm:default') %}
nvm.default:
  cmd.run:
    - name: nvm alias default {{ pillar['nvm']['default'] }}
    - unless: nvm alias default | grep {{ pillar['nvm']['default'] }}
    - runas: {{ user }}
    - require:
      - cmd: nvm.core
      - cmd: nvm.node.{{ pillar['nvm']['default'] }}
{% endif %}

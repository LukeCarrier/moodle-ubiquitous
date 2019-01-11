#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - java-base

gocd.key:
  cmd.run:
    - name: apt-key adv --keyserver hkp://pool.sks-keyservers.net:80 --recv-keys 8816C449
    - unless: apt-key list | grep 8816C449

gocd.repo:
  pkgrepo.managed:
    - name: deb https://download.gocd.io /
    - file: /etc/apt/sources.list.d/gocd.list
    - require:
      - cmd: gocd.key

gocd.ssh:
  file.directory:
    - name: /var/go/.ssh
    - user: go
    - group: go
    - mode: 0700

gocd.ssh.config:
  file.managed:
    - name: /var/go/.ssh/config
    - source: salt://gocd-base/ssh/config
    - user: go
    - group: go
    - mode: 0600
    - require:
      - file: gocd.ssh

{% if salt['pillar.get']('gocd-deploy:known-hosts') %}
gocd.ssh.known-hosts:
  file.managed:
    - name: /var/go/.ssh/known_hosts
    - contents_pillar: gocd-deploy:known-hosts
    - user: go
    - group: go
    - mode: 0600
    - require:
      - file: gocd.ssh
{% endif %}

{% for name in salt['pillar.get']('gocd-deploy:identities', {}).keys() %}
gocd.ssh.identity.{{ name }}:
  file.managed:
    - name: /var/go/.ssh/{{ name }}
    - contents_pillar: gocd-deploy:identities:{{ name }}
    - user: go
    - group: go
    - mode: 0600
    - require:
      - file: gocd.ssh
{% endfor %}

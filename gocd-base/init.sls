#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - java-base

'/etc/apt/sources.list.d/gocd.list':
  file.managed:
    - source: salt://gocd-base/lists/gocd.list
    - user: root
    - group: root
    - mode: 0644
  cmd.run:
    - name: apt-key adv --keyserver pgp.mit.edu --recv-keys 8816C449
    - unless: apt-key list | grep 8816C449

/var/go/.ssh:
  file.directory:
    - user: go
    - group: go
    - mode: 0700

/var/go/.ssh/config:
  file.managed:
    - source: salt://gocd-base/ssh/config
    - user: go
    - group: go
    - mode: 0600
    - require:
      - file: /var/go/.ssh

{% if salt['pillar.get']('gocd-deploy:known-hosts') %}
/var/go/.ssh/known_hosts:
  file.managed:
    - contents_pillar: gocd-deploy:known-hosts
    - user: go
    - group: go
    - mode: 0600
    - require:
      - file: /var/go/.ssh
{% endif %}

{% for name in salt['pillar.get']('gocd-deploy:identities', {}).keys() %}
/var/go/.ssh/{{ name }}:
  file.managed:
    - contents_pillar: gocd-deploy:identities:{{ name }}
    - user: go
    - group: go
    - mode: 0600
    - require:
      - file: /var/go/.ssh
{% endfor %}

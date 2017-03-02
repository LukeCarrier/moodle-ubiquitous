#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

'/etc/apt/sources.list.d/gocd.list':
  file.managed:
    - source: salt://gocd-base/lists/gocd.list
    - user: root
    - group: root
    - mode: 0644
  cmd.run:
    - name: apt-key adv --keyserver pgp.mit.edu --recv-keys 8816C449
    - unless: apt-key list | grep 8816C449

oracle-java.ppa:
  pkgrepo.managed:
    - humanname: Oracle Java (JDK) 7 / 8 / 9 Installer PPA
    - ppa: webupd8team/java

oracle-java.license.select:
  debconf.set:
    - name: 'oracle-java8-installer'
    - data:
        'shared/accepted-oracle-license-v1-1': { 'type': 'boolean', 'value': True }
    - require:
      - pkgrepo: oracle-java.ppa

oracle-java.java8:
  pkg.installed:
    - pkgs:
      - oracle-java8-installer
      - oracle-java8-set-default
    - require:
      - debconf: oracle-java.license.select

/var/go/.ssh:
  file.directory:
    - user: go
    - group: go
    - mode: 0700

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

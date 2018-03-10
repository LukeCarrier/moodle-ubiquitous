#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

oracle-java.ppa:
  pkgrepo.managed:
    - humanname: Oracle Java (JDK) 7 / 8 / 9 Installer PPA
    - ppa: webupd8team/java
    - keyserver: hkp://pool.sks-keyservers.net:80

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
      - pkgrepo: oracle-java.ppa

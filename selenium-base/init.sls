#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - java-base

/opt/selenium:
  file.directory:
    - user: root
    - group: root
    - mode: 0755

/opt/selenium/selenium-server.jar:
  file.managed:
    - source: {{ pillar['selenium']['server_jar']['source'] }}
    - source_hash: {{ pillar['selenium']['server_jar']['source_hash'] }}
    - require:
      - file: /opt/selenium

selenium:
  user.present:
    - fullname: Selenium user
    - shell: /bin/bash
    - home: /var/lib/selenium
    - gid_from_name: true

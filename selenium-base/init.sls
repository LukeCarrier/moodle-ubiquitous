#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - java-base

selenium.root:
  file.directory:
    - name: /opt/selenium
    - user: root
    - group: root
    - mode: 0755

selenium.binary:
  file.managed:
    - name: /opt/selenium/selenium-server.jar
    - source: {{ pillar['selenium']['server_jar']['source'] }}
    - source_hash: {{ pillar['selenium']['server_jar']['source_hash'] }}
    - require:
      - selenium.root

selenium.user:
  user.present:
    - name: selenium
    - fullname: Selenium user
    - shell: /bin/bash
    - home: /var/lib/selenium
    - gid_from_name: true

#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

/opt/selenium:
  file.directory:
    - user: root
    - group: root
    - mode: 0755

/opt/selenium/selenium-server.jar:
  file.managed:
    - source: salt://cache/selenium-server-standalone-2.53.0.jar
    - require:
      - file: /opt/selenium

java-1.8.0-openjdk-headless:
  pkg.installed

selenium:
  user.present:
    - fullname: Selenium user
    - shell: /bin/bash
    - home: /var/lib/selenium
    - gid_from_name: true

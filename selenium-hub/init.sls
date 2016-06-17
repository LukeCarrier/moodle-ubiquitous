#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke.carrier@floream.com>
# @copyright 2015 Floream Limited
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

/etc/systemd/system/selenium-hub.service:
  file.managed:
    - source: salt://selenium-hub/systemd/selenium-hub.service

selenium-hub:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/systemd/system/selenium-hub.service
      - file: /opt/selenium/selenium-server.jar

#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke.carrier@floream.com>
# @copyright 2015 Floream Limited
#

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
      - pkg: java-1.8.0-openjdk-headless
      - user: selenium

/etc/firewalld/services/selenium-hub.xml:
  file.managed:
    - source: salt://selenium-hub/firewalld/selenium-hub.xml

public:
  firewalld.present:
    - services:
      - selenium-hub
    - require:
      - file: /etc/firewalld/services/selenium-hub.xml
    - require_in:
      - firewalld.reload

'selenium-hub: firewall-cmd --runtime-to-permanent':
  cmd.run:
    - name: firewall-cmd --runtime-to-permanent
    - require:
      - firewalld: public

#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke.carrier@floream.com>
# @copyright 2015 Floream Limited
#

rpmforge-release:
  pkg.installed:
    - sources:
      - rpmforge-release: salt://cache/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm

xorg-x11-server-Xvfb:
  pkg.installed

x11vnc:
  pkg.installed:
    - require:
      - pkg: rpmforge-release
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/systemd/system/x11vnc.service
      - file: /etc/systemd/system/xvfb.service

/etc/systemd/system/selenium-node.service:
  file.managed:
    - source: salt://selenium-node-base/systemd/selenium-node.service

/etc/systemd/system/xvfb.service:
  file.managed:
    - source: salt://selenium-node-base/systemd/xvfb.service

/etc/systemd/system/x11vnc.service:
  file.managed:
    - source: salt://selenium-node-base/systemd/x11vnc.service

selenium-node:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/systemd/system/selenium-node.service
      - file: /etc/systemd/system/xvfb.service
      - file: /opt/selenium/selenium-server.jar
      - pkg: java-1.8.0-openjdk-headless
      - pkg: xorg-x11-server-Xvfb

/etc/firewalld/services/selenium-node.xml:
  file.managed:
    - source: salt://selenium-node-base/firewalld/selenium-node.xml

/etc/firewalld/services/x11vnc.xml:
  file.managed:
    - source: salt://selenium-node-base/firewalld/x11vnc.xml

public:
  firewalld.present:
    - services:
      - selenium-node
      - x11vnc
    - require:
      - file: /etc/firewalld/services/selenium-node.xml
      - file: /etc/firewalld/services/x11vnc.xml
    - require:
      - service: firewalld.reload

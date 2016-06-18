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

/etc/systemd/system/xvfb.service:
  file.managed:
    - source: salt://selenium-node/systemd/xvfb.service

xvfb:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/systemd/system/xvfb.service
      - pkg: xorg-x11-server-Xvfb

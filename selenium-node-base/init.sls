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
      - pkg: x11vnc

/etc/systemd/system/xvfb.service:
  file.managed:
    - source: salt://selenium-node-base/systemd/xvfb.service

/etc/systemd/system/x11vnc.service:
  file.managed:
    - source: salt://selenium-node-base/systemd/x11vnc.service

xvfb:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/systemd/system/xvfb.service
      - pkg: xorg-x11-server-Xvfb

/etc/firewalld/services/x11vnc.xml:
  file.managed:
    - source: salt://selenium-node-base/firewalld/x11vnc.xml

public:
  firewalld.present:
    - services:
      - x11vnc
    - require:
      - file: /etc/firewalld/services/x11vnc.xml
    - require_in:
      - firewalld.reload

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

/etc/systemd/system/xvfb.service:
  file.managed:
    - source: salt://selenium-node-base/systemd/xvfb.service

xvfb:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/systemd/system/xvfb.service
      - pkg: xorg-x11-server-Xvfb

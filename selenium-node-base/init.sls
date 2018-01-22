#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - base
  - selenium-base

selenium-node.x11vnc.pkgs:
  pkg.installed:
    - pkgs:
      - x11vnc
      - xvfb

selenium-node.fonts:
  pkg.installed:
    - pkgs:
      - fonts-liberation
      - ttf-ubuntu-font-family

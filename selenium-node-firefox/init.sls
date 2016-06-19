#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke.carrier@floream.com>
# @copyright 2015 Floream Limited
#

firefox:
  pkg.installed

selenium-node.restart:
  service.running:
    - name: selenium-node
    - reload: True
    - watch:
      - file: /opt/selenium/node.json

/opt/selenium/node.json:
  file.managed:
  - source: salt://selenium-node-firefox/selenium/node.json

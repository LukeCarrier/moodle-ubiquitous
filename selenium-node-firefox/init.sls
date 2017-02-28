#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - base
  - selenium-base

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

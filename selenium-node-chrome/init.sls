#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

/etc/yum.repos.d/google-chrome.repo:
  file.managed:
    - source: salt://selenium-node-chrome/repos/google-chrome.repo
    - user: root
    - group: root
    - mode: 0644

google-chrome-stable:
  pkg.installed:
    - require:
      - file: /etc/yum.repos.d/google-chrome.repo

chromedriver:
  archive.extracted:
    - name: /opt/selenium/chromedriver
    - source: salt://cache/chromedriver-linux64-2.22.zip
    - archive_format: zip
  file.managed:
    - name: /opt/selenium/chromedriver/chromedriver
    - mode: 0755
    - watch:
      - archive: chromedriver

selenium-node.restart:
  service.running:
    - name: selenium-node
    - reload: True
    - watch:
      - archive: chromedriver
      - file: /opt/selenium/node.json

/opt/selenium/node.json:
  file.managed:
    - source: salt://selenium-node-chrome/selenium/node.json

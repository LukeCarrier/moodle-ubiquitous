#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - base
  - selenium-base
  - selenium-node-base

google-chrome.repo:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/google-chrome.list
    - humanname:
    - name: deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main
    - key_url: https://dl.google.com/linux/linux_signing_key.pub

google-chrome.pkg:
  pkg.installed:
    - pkgs:
      - google-chrome-stable
    - require:
      - pkgrepo: google-chrome.repo

chromedriver:
  archive.extracted:
    - name: /opt/selenium/chromedriver
    - source: {{ pillar['selenium']['chromedriver']['source'] }}
    - source_hash: {{ pillar['selenium']['chromedriver']['source_hash'] }}
    - archive_format: zip
    - enforce_toplevel: False
  file.managed:
    - name: /opt/selenium/chromedriver/chromedriver
    - mode: 0755
    - watch:
      - archive: chromedriver

{% if pillar['systemd']['apply'] %}
selenium-node.restart:
  service.running:
    - name: selenium-node
    - reload: True
    - watch:
      - archive: chromedriver
      - file: /opt/selenium/node.json
{% endif %}

/opt/selenium/node.json:
  file.managed:
    - source: salt://selenium-node-chrome/selenium/node.json.jinja
    - template: jinja

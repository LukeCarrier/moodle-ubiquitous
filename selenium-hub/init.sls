#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - base
  - selenium-base

selenium-hub.systemd:
  file.managed:
    - name: /etc/systemd/system/selenium-hub.service
    - source: salt://selenium-hub/systemd/selenium-hub.service

selenium-hub.config:
  file.managed:
    - name: /opt/selenium/hub.json
    - source: salt://selenium-hub/selenium/hub.json.jinja
    - template: jinja

{% if pillar['systemd']['apply'] %}
selenium-hub.service:
  service.running:
    - name: selenium-hub
    - enable: True
    - reload: True
    - require:
      - selenium-hub.systemd
      - selenium.binary
      - selenium-hub.config
      - oracle-java.java8
{% endif %}


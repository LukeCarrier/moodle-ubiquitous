#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - base
  - selenium-base

/etc/systemd/system/selenium-hub.service:
  file.managed:
    - source: salt://selenium-hub/systemd/selenium-hub.service

{% if pillar['systemd']['apply'] %}
selenium-hub:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/systemd/system/selenium-hub.service
      - file: /opt/selenium/selenium-server.jar
      - file: /opt/selenium/hub.json
      - pkg: oracle-java.java8
      - user: selenium
{% endif %}

/opt/selenium/hub.json:
  file.managed:
    - source: salt://selenium-hub/selenium/hub.json.jinja
    - template: jinja

{% if pillar['iptables']['apply'] %}
nginx.iptables.http:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - proto: tcp
    - dport: 4444
    - save: True
    - require:
      - iptables: iptables.default.input.established
    - require_in:
      - iptables: iptables.default.input.drop
{% endif %}

#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

{% macro selenium_node_instance(
        instance, display, node_java_options,
        node_browser_name, node_port, vnc_port) %}
selenium-node.{{ instance }}.xvfb.systemd:
  file.managed:
    - name: /etc/systemd/system/xvfb.{{ instance }}.service
    - source: salt://selenium-node-base/systemd/xvfb.service.jinja
    - template: jinja
    - context:
      instance: {{ instance }}
      display: {{ display }}
    - user: root
    - group: root
    - mode: 0644

selenium-node.{{ instance }}.x11vnc.systemd:
  file.managed:
    - name: /etc/systemd/system/x11vnc.{{ instance }}.service
    - source: salt://selenium-node-base/systemd/x11vnc.service.jinja
    - template: jinja
    - context:
      instance: {{ instance }}
      display: {{ display }}
      vnc_port: {{ vnc_port }}
    - user: root
    - group: root
    - mode: 0644

selenium-node.{{ instance }}.selenium-node.config:
  file.managed:
    - name: /opt/selenium/node.{{ instance }}.json
    - source: salt://selenium-node-base/selenium/node.json.jinja
    - template: jinja
    - context:
      node_browser_name: {{ node_browser_name }}
      node_port: {{ node_port }}
    - user: root
    - group: root
    - mode: 0644

selenium-node.{{ instance }}.selenium-node.systemd:
  file.managed:
    - name: /etc/systemd/system/selenium-node.{{ instance }}.service
    - source: salt://selenium-node-base/systemd/selenium-node.service.jinja
    - template: jinja
    - context:
      instance: {{ instance }}
      display: {{ display }}
      node_java_options: {{ node_java_options | yaml_squote }}
      vnc_port: {{ vnc_port }}
    - user: root
    - group: root
    - mode: 0644

{% if pillar['systemd']['apply'] %}
selenium-node.{{ instance }}.x11vnc.service:
  service.running:
    - name: x11vnc.{{ instance }}
    - enable: True
    - reload: True
    - require:
      - selenium-node.{{ instance }}.x11vnc.systemd
      - selenium-node.{{ instance }}.xvfb.systemd

selenium-node.{{ instance }}.selenium-node.service:
  service.running:
    - name: selenium-node.{{ instance }}
    - enable: True
    - reload: True
    - require:
      - selenium-node.{{ instance }}.selenium-node.config
      - selenium-node.{{ instance }}.selenium-node.systemd
      - selenium-node.{{ instance }}.xvfb.systemd
      - selenium.binary
      - oracle-java.java8
{% endif %}

{% if pillar['iptables']['apply'] %}
selenium-node.{{ instance }}.x11vnc.iptables:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - proto: tcp
    - dport: {{ vnc_port }}
    - save: True
    - require:
      - iptables.default.input.established
    - require_in:
      -  iptables.default.input.drop

selenium-node.{{ instance }}.selenium-node.iptables:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - proto: tcp
    - dport: {{ node_port }}
    - save: True
    - require:
      - iptables.default.input.established
    - require_in:
      - iptables.default.input.drop
{% endif %}
{% endmacro %}

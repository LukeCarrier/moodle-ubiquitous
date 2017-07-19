#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

{% from 'selenium-node-base/macros.sls' import selenium_node_instance %}

include:
  - base
  - selenium-base
  - selenium-node-base

selenium-node-chrome.google-chrome.repo:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/google-chrome.list
    - humanname: Google Chrome
    - name: deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main
    - key_url: https://dl.google.com/linux/linux_signing_key.pub

selenium-node-chrome.google-chrome.pkg:
  pkg.installed:
    - pkgs:
      - google-chrome-stable
    - require:
      - selenium-node-chrome.google-chrome.repo

selenium-node-chrome.chromedriver:
  archive.extracted:
    - name: /opt/selenium/chromedriver
    - source: {{ pillar['selenium']['chromedriver']['source'] }}
    - source_hash: {{ pillar['selenium']['chromedriver']['source_hash'] }}
    - archive_format: zip
    - enforce_toplevel: False
  file.managed:
    - name: /opt/selenium/chromedriver/chromedriver
    - mode: 0755
    - replace: False
    - watch:
      - archive: selenium-node-chrome.chromedriver

{% for instance, config in pillar['selenium-node']['instances'].items() %}
{% set node_java_options = '-Dwebdriver.chrome.driver=/opt/selenium/chromedriver/chromedriver ' + config.get('node_java_options', '') %}
{{ selenium_node_instance(
        instance, config['display'], node_java_options, 'chrome',
        config['node_port'], config['vnc_port']) }}
{% endfor %}

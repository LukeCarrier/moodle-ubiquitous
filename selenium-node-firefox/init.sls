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

selenium-node-firefox.firefox:
  pkg.installed:
    - name: firefox

{% for instance, config in pillar['selenium-node']['instances'].items() %}
{% set node_java_options = config.get('node_java_options', '') %}
{{ selenium_node_instance(
        instance, config['display'], node_java_options, 'firefox',
        config['node_port'], config['vnc_port']) }}
{% endfor %}

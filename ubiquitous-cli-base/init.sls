#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - ubiquitous-cli-base

ubiquitous-cli:
  file.directory:
    - name: /usr/local/ubiquitous
    - user: root
    - group: root
    - mode: 0755

{% for dir in ['bin', 'etc', 'lib', 'share'] %}
ubiquitous-cli.{{ dir }}:
  file.directory:
    - name: /usr/local/ubiquitous/{{ dir }}
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: ubiquitous-cli
{% endfor %}

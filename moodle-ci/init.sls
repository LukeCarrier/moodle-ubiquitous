#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - ubiquitous-cli-base

{% for script in ['install-platform', 'prepare-component'] %}
moodle-ci.bin.{{ script }}:
  file.managed:
    - name: /usr/local/ubiquitous/bin/ubiquitous-{{ script }}-moodle
    - source: salt://moodle-ci/local/bin/ubiquitous-{{ script }}-moodle
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: ubiquitous-cli.bin
{% endfor %}

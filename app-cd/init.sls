#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - ubiquitous-cli-base

app-cd.lib.ubiquitous-cd-app:
  file.managed:
    - name: /usr/local/ubiquitous/lib/ubiquitous-cd-app
    - source: salt://app-cd/local/lib/ubiquitous-cd-app
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: ubiquitous-cli.lib

app-cd.bin.ubiquitous-apply-current-release-app:
  file.managed:
    - name: /usr/local/ubiquitous/bin/ubiquitous-apply-current-release-app
    - source: salt://app-cd/local/bin/ubiquitous-apply-current-release-app
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: ubiquitous-cli.bin
      - file: app-cd.lib.ubiquitous-cd-app

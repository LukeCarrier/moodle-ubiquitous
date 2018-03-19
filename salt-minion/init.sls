#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

salt-minion.list:
  file.managed:
    - name: /etc/apt/sources.list.d/saltstack.list
    - source: salt://salt-minion/lists/saltstack.list
    - user: root
    - group: root
    - mode: 0644

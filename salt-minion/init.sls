#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% from 'salt-minion/map.jinja' import salt_minion with context %}

salt-minion.list:
  file.managed:
    - name: /etc/apt/sources.list.d/saltstack.list
    - source: salt://salt-minion/lists/saltstack.list.jinja
    - template: jinja
    - context:
      variant: {{ salt_minion.variant }}
      osrelease: {{ salt_minion.nearest_lts.osrelease }}
      oscodename: {{ salt_minion.nearest_lts.oscodename }}
    - user: root
    - group: root
    - mode: 0644

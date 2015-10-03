#
# The Perfect Cluster: Moodle
#
# @author Luke Carrier <luke.carrier@floream.com>
# @copyright 2015 Floream Limited
#

#
# Salt master
#

salt-master:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: salt-master

#
# Firewall
#

/etc/firewalld/services/salt-master.xml:
  file:
    - managed
    - source: salt://salt/firewalld/salt-master.xml
    - require_in:
      - service: firewalld

public:
  firewalld.present:
    - services:
      - salt-master
      - ssh

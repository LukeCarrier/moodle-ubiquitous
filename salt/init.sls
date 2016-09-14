#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
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
  file.managed:
    - source: salt://salt/firewalld/salt-master.xml

public:
  firewalld.present:
    - services:
      - salt-master
    - require:
      - file: /etc/firewalld/services/salt-master.xml
    - require_in:
      - firewalld.reload

'salt: firewall-cmd --runtime-to-permanent':
  cmd.run:
    - name: firewall-cmd --runtime-to-permanent
    - require:
      - firewalld: public

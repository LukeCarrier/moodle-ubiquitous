#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - base

#
# Salt master
#

salt-master:
  pkg.installed: []
  service.running:
    - enable: True
    - require:
      - pkg: salt-master

salt-master.iptables.publish:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - proto: tcp
    - dport: 4505
    - save: True
    - require:
      - iptables: iptables.default.input.established
    - require_in:
      - iptables: iptables.default.input.drop

salt-master.iptables.ret:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - proto: tcp
    - dport: 4506
    - save: True
    - require:
      - iptables: iptables.default.input.established
    - require_in:
      - iptables: iptables.default.input.drop

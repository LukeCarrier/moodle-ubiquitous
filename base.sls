#
# The Perfect Cluster: Moodle
#
# @author Luke Carrier <luke.carrier@floream.com>
# @copyright 2015 Floream Limited
#

#
# SSH daemon
#

openssh-server:
  pkg.installed: []

sshd:
  service.running:
    - require:
      - pkg: openssh-server

/etc/ssh/sshd_config:
  file:
    - managed
    - source: salt://base/sshd/sshd_config
    - require:
      - pkg: openssh-server

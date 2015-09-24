#
# The Perfect Cluster: Moodle
#
# @author Luke Carrier <luke.carrier@floream.com>
# @copyright 2015 Floream Limited
#

#
# Administrative user
#

admin:
  user.present:
    - fullname: Administrative user
    - shell: /bin/bash
    - home: /home/admin
    - uid: 1000
    - gid_from_name: True
    - groups:
      - wheel

/home/admin/.ssh:
  file.directory:
    - user: admin
    - group: admin
    - mode: 0700
    - require:
      - user: admin

/home/admin/.ssh/authorized_keys:
  file:
    - managed
    - source: salt://base/admin/authorized_keys
    - require:
      - user: admin
      - file: /home/admin/.ssh

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

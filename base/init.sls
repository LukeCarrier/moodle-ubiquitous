#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

#
# Administrative user
#

admin:
  user.present:
    - fullname: Administrative user
    - shell: /bin/bash
    - home: /home/admin
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
  file.managed:
    - source: salt://base/admin/authorized_keys
    - require:
      - user: admin
      - file: /home/admin/.ssh

#
# SaltStack repository
#

/etc/yum.repos.d/saltstack.repo:
  file.managed:
    - source: salt://base/repos/saltstack.repo
    - user: root
    - group: root
    - mode: 0644

#
# SSH daemon
#

openssh-server:
  pkg.installed

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://base/sshd/sshd_config
    - require:
      - pkg: openssh-server

sshd:
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: openssh-server
      - file: /etc/ssh/sshd_config

#
# FirewallD
#

firewalld:
  service.running:
    - name: firewalld
    - enable: True

public.base:
  firewalld.present:
    - name: public
    - services:
      - ssh
    - require:
      - pkg: openssh-server
    - require:
      - firewalld.reload

'firewall-cmd --runtime-to-permanent':
  cmd.run:
    - name: firewall-cmd --runtime-to-permanent
    - onchanges:
      - firewalld: '*'

firewalld.reload:
  service.running:
    - name: firewalld
    - reload: True
    - require_in:
      - cmd: 'firewall-cmd --runtime-to-permanent'

#
# SELinux
#

policycoreutils-python:
  pkg.installed

#
# NTP daemon
#

ntpd.packages:
  pkg.installed:
    - pkgs:
      - ntp
      - ntpdate

ntpd.service:
  service.running:
    - name: ntpd
    - enable: True
    - reload: True
    - require:
      - pkg: ntpd.packages

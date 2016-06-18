#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke.carrier@floream.com>
# @copyright 2015 Floream Limited
#

#
# Dependencies
#

ruby:
  pkg.installed:
    - pkgs:
      - gcc
      - gcc-c++
      - openssl-devel
      - ruby
      - ruby-devel
      - sqlite-devel

#
# MailCatcher
#

mailcatcher:
  user.present:
    - fullname: MailCatcher user
    - shell: /bin/bash
    - home: /var/mailcatcher
    - gid_from_name: true
  cmd.run:
    - name: gem install mailcatcher
    - user: mailcatcher
    - group: mailcatcher
    - require:
      - user: mailcatcher
  file.managed:
    - name: /etc/systemd/system/mailcatcher.service
    - source: salt://mail-debug/systemd/mailcatcher.service
    - user: root
    - group: root
    - mode: 0644
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/system/mailcatcher.service
      - cmd: gem install mailcatcher

#
# Firewall
#

/etc/firewalld/services/mailcatcher.xml:
  file.managed:
    - source: salt://mail-debug/firewalld/mailcatcher.xml
    - user: root
    - group: root

public:
  firewalld.present:
    - services:
      - mailcatcher
    - require:
      - file: /etc/firewalld/services/mailcatcher.xml

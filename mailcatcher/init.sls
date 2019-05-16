#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% from 'mailcatcher/map.jinja' import mailcatcher with context %}

mailcatcher.ruby:
  pkg.installed:
    - pkgs:
      - build-essential
      - libsqlite3-dev
      - ruby-dev

mailcatcher.user:
  user.present:
    - name: mailcatcher
    - fullname: MailCatcher user
    - shell: /bin/bash
    - home: /var/mailcatcher

mailcatcher.install:
  cmd.run:
    - name: gem install --user-install mailcatcher
    - runas: mailcatcher
    - require:
      - user: mailcatcher.user

mailcatcher.service.unit:
  file.managed:
    - name: /etc/systemd/system/mailcatcher.service
    - source: salt://mailcatcher/systemd/mailcatcher.service.jinja
    - template: jinja
    - context:
      ruby_version: {{ mailcatcher.ruby_version }}
    - user: root
    - group: root
    - mode: 0644

mailcatcher.service:
  service.running:
    - enable: True
    - require:
      - file: mailcatcher.service.unit
      - cmd: mailcatcher.install

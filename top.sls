#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

base:
  'roles:salt':
    - match: grain
    - salt

  'roles:gocd-server':
    - match: grain
    - certbot
    - gocd-server
  'roles:gocd-agent':
    - match: grain
    - gocd-agent

  'roles:named':
    - match: grain
    - named

  'roles:app':
    - match: grain
    - app
    - app-gocd-agent
    - certbot

  'roles:db-pgsql':
    - match: grain
    - db-pgsql

  'roles:mount-cifs':
    - match: grain
    - mount-cifs

  'roles:app-debug':
    - match: grain
    - app-debug

  'roles:mail-debug':
    - match: grain
    - mail-debug

  'roles:selenium':
    - match: grain
    - selenium-base
  'roles:selenium-hub':
    - match: grain
    - selenium-hub
  'roles:selenium-node':
    - match: grain
    - selenium-node-base
  'roles:selenium-node-chrome':
    - match: grain
    - selenium-node-chrome
  'roles:selenium-node-firefox':
    - match: grain
    - selenium-node-firefox

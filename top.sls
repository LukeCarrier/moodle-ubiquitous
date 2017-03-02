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
    - gocd-server
  'roles:gocd-agent':
    - match: grain
    - gocd-agent

  'roles:app':
    - match: grain
    - app

  'roles:db':
    - match: grain
    - db

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

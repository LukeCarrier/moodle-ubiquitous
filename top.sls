#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke.carrier@floream.com>
# @copyright 2015 Floream Limited
#

base:
  '*':
    - base
  'app-*':
    - app
  'app-debug-*':
    - app
    - app-debug
  'db-*':
    - db
  'mail-debug':
    - mail-debug
  'salt':
    - salt
  'selenium-node-*':
    - selenium-node
  'selenium-node-chrome':
    - selenium-node-chrome
  'selenium-node-firefox':
    - selenium-node-firefox

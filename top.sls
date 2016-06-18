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
  'db-*':
    - db
  'salt':
    - salt

  'app-debug-*':
    - app
    - app-debug
  'mail-debug':
    - mail-debug

  'selenium-grid':
    - selenium-grid
  'selenium-node-*':
    - selenium-node
  'selenium-node-chrome':
    - selenium-node-chrome
  'selenium-node-firefox':
    - selenium-node-firefox

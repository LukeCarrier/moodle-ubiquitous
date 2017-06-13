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

  'roles:app-base':
    - match: grain
    - app
    - certbot

  'roles:app-debug':
    - match: grain
    - app-debug

  'roles:app-default-release':
    - match: grain
    - app-default-release

  'roles:app-error-pages':
    - match: grain
    - app-error-pages

  'roles:app-gocd-agent':
    - match: grain
    - app-gocd-agent

  'roles:app-lets-encrypt':
    - match: grain
    - app-lets-encrypt

  'roles:db-pgsql':
    - match: grain
    - db-pgsql

  'roles:av-sophos':
    - match: grain
    - av-sophos

  'roles:mount-cifs':
    - match: grain
    - mount-cifs

  'roles:mail-debug':
    - match: grain
    - mail-debug

  'roles:mail-relay':
    - match: grain
    - mail-relay

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

  'roles:app-moodle':
    - match: grain
    - app-moodle

  'roles:app-saml':
    - match: grain
    - app-saml

#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

base:
  'roles:admin':
    - match: grain
    - admin

  'roles:nftables':
    - match: grain
    - nftables

  'roles:ntp':
    - match: grain
    - ntp

  'roles:sshd':
    - match: grain
    - sshd

  'roles:salt':
    - match: grain
    - salt
  'roles:salt-minion':
    - match: grain
    - salt-minion

  'roles:gocd-server':
    - match: grain
    - certbot
    - gocd-server
  'roles:gocd-agent':
    - match: grain
    - gocd-agent

  'roles:moodle-componentmgr':
    - match: grain
    - moodle-componentmgr
  'roles:moodle-ci':
    - match: grain
    - moodle-ci

  'roles:nvm':
    - match: grain
    - nvm

  'roles:named':
    - match: grain
    - named

  'roles:web-moodle':
    - match: grain
    - web-moodle
    - certbot

  'roles:app-moodle':
    - match: grain
    - app-moodle
  'roles:app-saml':
    - match: grain
    - app-saml

  'roles:web-cd':
    - match: grain
    - web-cd
  'roles:web-debug':
    - match: grain
    - web-debug
  'roles:web-moodle-debug':
    - match: grain
    - web-moodle-debug
  'roles:web-default-release':
    - match: grain
    - web-default-release
  'roles:web-error-pages':
    - match: grain
    - web-error-pages
  'roles:web-ssl-certs':
    - match: grain
    - web-ssl-certs
  'roles:web-lets-encrypt':
    - match: grain
    - web-lets-encrypt

  'roles:app-crontab':
    - match: grain
    - app-crontab
  'roles:app-debug':
    - match: grain
    - app-debug
  'roles:app-moodle-debug':
    - match: grain
    - app-moodle-debug
  'roles:app-cd':
    - match: grain
    - app-cd
  'roles:app-default-release':
    - match: grain
    - app-default-release
  'roles:app-moodle-default-release':
    - match: grain
    - app-moodle-default-release
  'roles:app-tideways':
    - match: grain
    - app-tideways

  'roles:db-mssql':
    - match: grain
    - db-mssql

  'roles:db-pgsql':
    - match: grain
    - db-pgsql

  'roles:av-sophos':
    - match: grain
    - av-sophos

  'roles:datadog-agent':
    - match: grain
    - datadog-agent

  'roles:haproxy':
    - match: grain
    - haproxy

  'roles:mount-cifs':
    - match: grain
    - mount-cifs

  'roles:mail-debug':
    - match: grain
    - mail-debug

  'roles:postfix':
    - match: grain
    - postfix

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

  'roles:redis':
    - match: grain
    - redis
  'roles:redis-sentinel':
    - match: grain
    - redis-sentinel
  'roles:redis-sentinel-tunnel':
    - match: grain
    - redis-sentinel-tunnel

  'roles:twemproxy':
    - match: grain
    - twemproxy

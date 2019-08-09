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
  'roles:pam':
    - match: grain
    - pam

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


  'roles:nfs.server':
    - match: grain
    - nfs.server
  'roles:tcpwrappers':
    - match: grain
    - tcpwrappers

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

  'roles:php.igbinary':
    - match: grain
    - php.igbinary
  'roles:php.redis':
    - match: grain
    - php.redis
  'roles:php.sqlsrv':
    - match: grain
    - php.sqlsrv

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
  'roles:app-tideways':
    - match: grain
    - app-tideways

  'roles:mssql':
    - match: grain
    - mssql

  'roles:postgresql':
    - match: grain
    - postgresql

  'roles:clamav':
    - match: grain
    - clamav

  'roles:datadog-agent':
    - match: grain
    - datadog-agent

  'roles:haproxy':
    - match: grain
    - haproxy

  'roles:mount-cifs':
    - match: grain
    - mount-cifs

  'roles:mailcatcher':
    - match: grain
    - mailcatcher

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

#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% set default_mynetworks = [
  '127.0.0.0/8',
  '192.168.120.0/24',
  '[::ffff:127.0.0.0]/104',
  '[::1]/128',
] %}

{% set default_destinations = [
  '$myhostname',
  'app-debug-1.moodle',
  'localhost.moodle',
  'localhost',
] %}

mail-relay.postfix.debconf:
  debconf.set:
    - name: postfix
    - data:
        postfix/relayhost:
          type: string
          value: {{ pillar['mail-relay']['relayhost'] | yaml }}
        postfix/mailbox_limit:
          type: string
          value: {{ salt['pillar.get']('mail-relay:mailbox_limit', '51200000') }}
        postfix/mailname:
          type: string
          value: {{ salt['pillar.get']('mail-relay:mailname', grains['fqdn']) | yaml }}
        postfix/main_mailer_type:
          type: string
          value: Internet Site
        postfix/mynetworks:
          type: string
          value: {{ salt['pillar.get']('mail-relay:mynetworks', default_mynetworks) | join(' ') }}
        postfix/protocols:
          type: string
          value: all
        postfix/recipient_delim:
          type: string
          value: '+'
        postfix/destinations:
          type: string
          value: {{ salt['pillar.get']('mail-relay:destinations', default_destinations) | join(', ') | yaml }}
        postfix/chattr:
          type: boolean
          value: 'false'
        postfix/root_address:
          type: string
          value: {{ salt['pillar.get']('mail-relay:root_address', '') }}

mail-relay.postfix.pkgs:
  pkg.latest:
    - pkgs:
      - libsasl2-modules
      - postfix
    - require:
      - debconf: mail-relay.postfix.debconf

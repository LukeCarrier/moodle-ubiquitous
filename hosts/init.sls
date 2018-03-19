#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

hosts./etc/hosts:
  file.managed:
    - source: salt://hosts/network/hosts.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

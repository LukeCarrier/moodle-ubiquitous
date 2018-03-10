#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

#
# Salt master
#

salt-master:
  pkg.installed: []
  service.running:
    - enable: True
    - require:
      - pkg: salt-master

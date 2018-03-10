#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

ntp:
  pkg.installed:
    - pkgs:
      - ntp
      - ntpdate

{% if pillar['systemd']['apply'] %}
ntp.service:
  service.running:
    - name: ntp
    - enable: True
    - require:
      - pkg: ntp
{% endif %}

#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

nftables.pkgs:
  pkg.installed:
    - name: nftables

{% if salt['pillar.get']('nftables:enable', False) %}
nftables.nftables.conf:
  file.managed:
    - name: /etc/nftables.conf
    - source: salt://nftables/nftables/nftables.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0755
    - require:
      - pkg: nftables.pkgs

{% if pillar['systemd']['apply'] %}
nftables.reload:
  cmd.run:
    - name: systemctl reload nftables
    - onchanges:
      - file: nftables.nftables.conf
    - require:
      - service: nftables.service.status
{% endif %}
{% endif %}

{% if pillar['systemd']['apply'] %}
nftables.service.status:
  service.{% if pillar['nftables']['enable'] %}running{% else %}dead{% endif %}:
    - name: nftables
    - require:
      - file: nftables.nftables.conf

nftables.service.enabled:
  service.{% if pillar['nftables']['enable'] %}en{% else %}dis{% endif %}abled:
    - name: nftables
    - require:
      - file: nftables.nftables.conf
{% endif %}

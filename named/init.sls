#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - base

named:
  pkg.installed:
    - pkgs:
      - bind9
      - dnsutils

{% if pillar['iptables']['apply'] %}
{% for protocol in ['tcp', 'udp']%}
named.iptables.dns-{{ protocol }}:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - proto: {{ protocol }}
    - dport: 53
    - save: True
    - require:
      - iptables: iptables.default.input.established
    - require_in:
      - iptables: iptables.default.input.drop
{% endfor %}
{% endif %}

/etc/bind/named.conf.options:
  file.managed:
    - source: salt://named/named/named.conf.options.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

{% for domain, zone in pillar['named']['zones'].items() %}
/etc/bind/db.{{ domain }}:
  file.managed:
    - source: salt://named/named/db.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
    - user: root
    - group: root
    - mode: 0644
    - require_in:
      - file: /etc/bind/named.conf.local
    - watch_in:
      - service: named.reload
{% endfor %}

/etc/bind/named.conf.local:
  file.managed:
    - source: salt://named/named/named.conf.local.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

named.service:
  service.running:
    - name: bind9
    - require:
      - pkg: named

named.reload:
  service.running:
    - name: bind9
    - watch:
      - file: /etc/bind/named.conf.local
      - file: /etc/bind/named.conf.options

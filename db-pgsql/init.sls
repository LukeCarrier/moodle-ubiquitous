#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - base

#
# PostgreSQL server
#

postgresql-server:
  pkg.installed:
    - name: postgresql-9.5
    - allow_updates: True

{% if pillar['systemd']['apply'] %}
postgresql-server.service:
  service.running:
    - name: postgresql
    - enable: True
    - require:
      - pkg: postgresql-server
      - file: postgresql-server.postgresql.conf
      - file: postgresql-server.pg_hba.conf
{% endif %}

postgresql-server.postgresql.conf:
  file.managed:
    - name: /etc/postgresql/9.5/main/postgresql.conf
    - source: salt://db-pgsql/postgres/postgresql.conf
    - user: postgres
    - group: postgres
    - mode: 0644
    - require:
      - pkg: postgresql-server

postgresql-server.pg_hba.conf:
  file.managed:
    - name: /etc/postgresql/9.5/main/pg_hba.conf
    - source: salt://db-pgsql/postgres/pg_hba.conf.jinja
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 0600
    - require:
      - pkg: postgresql-server

{% if pillar['iptables']['apply'] %}
postgresql-server.iptables.pgsql:
  iptables.append:
    - chain: INPUT
    - jump: ACCEPT
    - proto: tcp
    - dport: 5432
    - save: True
    - require:
      - iptables: iptables.default.input.established
    - require_in:
      - iptables: iptables.default.input.drop
{% endif %}

{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
moodle.{{ domain }}.postgres:
  postgres_user.present:
    - user: postgres
    - name: {{ platform['pgsql']['user']['name'] }}
    - password: {{ platform['pgsql']['user']['password'] }}
{% if pillar['systemd']['apply'] %}
    - require:
      - service: postgresql-server.service
{% endif %}
  postgres_database.present:
    - user: postgres
    - name: {{ platform['pgsql']['database']['name'] }}
    - encoding: {{ platform['pgsql']['database']['encoding'] }}
    - owner: {{ platform['pgsql']['user']['name'] }}
    - require:
      - postgres_user: moodle.{{ domain }}.postgres
{% if pillar['systemd']['apply'] %}
      - service: postgresql-server.service
{% endif %}
{% endfor %}

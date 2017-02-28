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
  service.running:
    - name: postgresql@9.5-main
    - enable: True
    - require:
      - file: postgresql-server.postgresql.conf
      - file: postgresql-server.pg_hba.conf

postgresql-server.postgresql.conf:
  file.managed:
    - name: /etc/postgresql/9.5/main/postgresql.conf
    - source: salt://db/postgres/postgresql.conf
    - user: postgres
    - group: postgres
    - mode: 0644
    - require:
      - pkg: postgresql-server

postgresql-server.pg_hba.conf:
  file.managed:
    - name: /etc/postgresql/9.5/main/pg_hba.conf
    - source: salt://db/postgres/pg_hba.conf
    - user: postgres
    - group: postgres
    - mode: 0600
    - require:
      - pkg: postgresql-server

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

{% for domain, platform in pillar['platforms'].items() %}
moodle.{{ domain }}.postgres:
  postgres_user.present:
    - user: postgres
    - name: {{ platform['user']['name'] }}
    - password: {{ platform['user']['password'] }}
    - require:
      - service: postgresql-server
  postgres_database.present:
    - user: postgres
    - name: {{ platform['database']['name'] }}
    - encoding: {{ platform['database']['encoding'] }}
    - owner: {{ platform['user']['name'] }}
    - require:
      - postgres_user: moodle.{{ domain }}.postgres
      - service: postgresql-server
{% endfor %}

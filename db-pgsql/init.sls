#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% from "db-pgsql/map.jinja" import postgresql with context %}
{% set cluster_user = salt['pillar.get']('postgresql:user', 'postgres') %}
{% set cluster_group = salt['pillar.get']('postgresql:group', 'postgres') %}

include:
  - ubiquitous-cli-base

postgresql-server:
  pkg.installed:
    - pkgs: {{ postgresql.packages | yaml }}
    - allow_updates: True

{% if pillar['systemd']['apply'] %}
postgresql-server.service:
  service.running:
    - name: postgresql
    - enable: True

postgresql-server.reload:
  service.running:
    - name: postgresql
    - watch:
      - cmd: postgresql-server.cluster
      - file: postgresql-server.postgresql.conf
      - file: postgresql-server.pg_hba.conf
{% endif %}

postgresql-server.cluster:
  cmd.run:
    - name: pg_createcluster {{ postgresql.version }} main
    - unless: test -d /var/lib/postgresql/{{ postgresql.version }}/main

postgresql-server.postgresql.conf:
  file.managed:
    - name: /etc/postgresql/{{ postgresql.version }}/main/postgresql.conf
    - source: salt://db-pgsql/postgres/postgresql.conf.jinja
    - template: jinja
    - context:
      config: {{ postgresql.config | yaml }}
    - user: postgres
    - group: postgres
    - mode: 0644
    - require:
      - cmd: postgresql-server.cluster

postgresql-server.pg_hba.conf:
  file.managed:
    - name: /etc/postgresql/{{ postgresql.version }}/main/pg_hba.conf
    - source: salt://db-pgsql/postgres/pg_hba.conf.jinja
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 0600
    - require:
      - cmd: postgresql-server.cluster

db-pgsql.local.etc.pgsql:
  file.managed:
    - name: /usr/local/ubiquitous/etc/ubiquitous-pgsql
    - source: salt://db-pgsql/local/etc/ubiquitous-pgsql.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - require:
      - file: ubiquitous-cli.etc

db-pgsql.local.bin.pgsql-cluster:
  file.managed:
    - name: /usr/local/ubiquitous/bin/ubiquitous-pgsql-cluster
    - source: salt://db-pgsql/local/bin/ubiquitous-pgsql-cluster
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: ubiquitous-cli.bin

{% if not salt['pillar.get']('postgresql:defer_creation', False) %}
{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
{% if 'pgsql' in platform %}
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
    - template: template0
    - encoding: {{ platform['pgsql']['database']['encoding'] }}
    - owner: {{ platform['pgsql']['user']['name'] }}
    - require:
      - postgres_user: moodle.{{ domain }}.postgres
{% if pillar['systemd']['apply'] %}
      - service: postgresql-server.service
{% endif %}
{% endif %}
{% endfor %}
{% endif %}

#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% from 'postgresql/map.jinja' import postgresql with context %}
{% set cluster_user = salt['pillar.get']('postgresql:user', 'postgres') %}
{% set cluster_group = salt['pillar.get']('postgresql:group', 'postgres') %}

include:
  - ubiquitous-cli-base

postgresql.pkgs:
  pkg.latest:
    - pkgs: {{ postgresql.packages | yaml }}

{% if pillar['systemd']['apply'] %}
postgresql.service:
  service.running:
    - name: postgresql
    - enable: True

postgresql.reload:
  cmd.run:
    - name: systemctl restart postgresql@{{ postgresql.version }}-main
    - onchanges:
      - cmd: postgresql.cluster
      - file: postgresql.postgresql.conf
      - file: postgresql.pg_hba.conf
{% endif %}

postgresql.cluster:
  cmd.run:
    - name: pg_createcluster {{ postgresql.version }} main
    - unless: test -d /var/lib/postgresql/{{ postgresql.version }}/main

postgresql.postgresql.conf:
  file.managed:
    - name: /etc/postgresql/{{ postgresql.version }}/main/postgresql.conf
    - source: salt://postgresql/postgres/postgresql.conf.jinja
    - template: jinja
    - context:
      config: {{ postgresql.config | yaml }}
    - user: postgres
    - group: postgres
    - mode: 0644
    - require:
      - cmd: postgresql.cluster

postgresql.pg_hba.conf:
  file.managed:
    - name: /etc/postgresql/{{ postgresql.version }}/main/pg_hba.conf
    - source: salt://postgresql/postgres/pg_hba.conf.jinja
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 0600
    - require:
      - cmd: postgresql.cluster

postgresql.local.etc.pgsql:
  file.managed:
    - name: /usr/local/ubiquitous/etc/ubiquitous-pgsql
    - source: salt://postgresql/local/etc/ubiquitous-pgsql.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - require:
      - file: ubiquitous-cli.etc

postgresql.local.bin.pgsql-cluster:
  file.managed:
    - name: /usr/local/ubiquitous/bin/ubiquitous-pgsql-cluster
    - source: salt://postgresql/local/bin/ubiquitous-pgsql-cluster
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
      - service: postgresql.service
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
      - service: postgresql.service
{% endif %}
{% endif %}
{% endfor %}
{% endif %}

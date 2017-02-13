#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

#
# Firewall
#

public:
  firewalld.present:
    - services:
      - postgresql
    - require:
      - pkg: postgresql96-server
    - require_in:
      - firewalld.reload

#
# PostgreSQL server
#

pgdg-centos96:
  pkg.installed:
    - allow_updates: True
    - sources:
      - pgdg-centos96: https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm

postgresql96-server:
  pkg.installed:
    - require:
      - pkg: pgdg-centos96

postgresql-9.6:
  service.running:
    - enable: True
    - reload: True
    - require:
      - cmd: pg-initdb
      - pkg: postgresql96-server
    - watch:
      - file: /var/lib/pgsql/9.6/data/postgresql.conf
      - file: /var/lib/pgsql/9.6/data/pg_hba.conf

/var/lib/pgsql/9.6/data/postgresql.conf:
  file.managed:
    - source: salt://db/postgres/postgresql.conf
    - user: postgres
    - group: postgres
    - mode: 0600
    - require:
      - cmd: pg-initdb
      - pkg: postgresql96-server

/var/lib/pgsql/9.6/data/pg_hba.conf:
  file.managed:
    - source: salt://db/postgres/pg_hba.conf
    - user: postgres
    - group: postgres
    - mode: 0600
    - require:
      - cmd: pg-initdb
      - pkg: postgresql96-server

pg-initdb:
  cmd.wait:
    - name: /usr/pgsql-9.6/bin/initdb -D /var/lib/pgsql/9.6/data -E UTF8 --locale C
    - user: postgres
    - watch:
      - pkg: postgresql96-server
    - unless: ls /var/lib/pgsql/9.6/data/base
    - require:
      - pkg: postgresql96-server

moodle:
  postgres_user.present:
    - user: postgres
    - password: Password123
    - require:
      - cmd: pg-initdb
  postgres_database.present:
    - user: postgres
    - encoding: utf8
    - owner: moodle
    - require:
      - postgres_user: moodle
      - cmd: pg-initdb

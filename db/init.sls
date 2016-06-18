#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke.carrier@floream.com>
# @copyright 2015 Floream Limited
#

#
# Firewall
#

public:
  firewalld.present:
    - services:
      - postgresql
    - require:
      - pkg: postgresql94-server
    - require_in:
      - firewalld.reload

#
# PostgreSQL server
#

pgdg-centos94:
  pkg.installed:
    - allow_updates: True
    - sources:
      - pgdg-centos94: http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-1.noarch.rpm

postgresql94-server:
  pkg.installed:
    - require:
      - pkg: pgdg-centos94

postgresql-9.4:
  service.running:
    - enable: True
    - reload: True
    - require:
      - cmd: pg-initdb
      - pkg: postgresql94-server
    - watch:
      - file: /var/lib/pgsql/9.4/data/postgresql.conf
      - file: /var/lib/pgsql/9.4/data/pg_hba.conf

/var/lib/pgsql/9.4/data/postgresql.conf:
  file.managed:
    - source: salt://db/postgres/postgresql.conf
    - user: postgres
    - group: postgres
    - mode: 0600
    - require:
      - cmd: pg-initdb
      - pkg: postgresql94-server

/var/lib/pgsql/9.4/data/pg_hba.conf:
  file.managed:
    - source: salt://db/postgres/pg_hba.conf
    - user: postgres
    - group: postgres
    - mode: 0600
    - require:
      - cmd: pg-initdb
      - pkg: postgresql94-server

pg-initdb:
  cmd.wait:
    - name: /usr/pgsql-9.4/bin/initdb -D /var/lib/pgsql/9.4/data -E UTF8 --locale C
    - user: postgres
    - watch:
      - pkg: postgresql94-server
    - unless: ls /var/lib/pgsql/9.4/data/base
    - require:
      - pkg: postgresql94-server

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

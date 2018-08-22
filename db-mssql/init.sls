#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

db-mssql.repo.mssql-server-2017:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/mssql-server-2017.list
    - hummanname: Microsoft SQL Server 2017
    - name: deb [arch=amd64] https://packages.microsoft.com/ubuntu/16.04/mssql-server-2017 xenial main
    - key_url: https://packages.microsoft.com/keys/microsoft.asc

db-mssql.repo.microsoft:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/microsoft.list
    - hummanname: Microsoft
    - name: deb [arch=amd64] https://packages.microsoft.com/ubuntu/16.04/prod xenial main
    - key_url: https://packages.microsoft.com/keys/microsoft.asc

db-mssql.pkg.server:
  pkg.installed:
    - name: mssql-server
    - require:
      - pkgrepo: db-mssql.repo.mssql-server-2017

db-mssql.server.setup:
  cmd.run:
    - name: /opt/mssql/bin/mssql-conf -n setup accept-eula
    - env:
      - MSSQL_PID: {{ pillar['db-mssql']['setup']['edition'] }}
      - MSSQL_SA_PASSWORD: {{ pillar['db-mssql']['setup']['sa_password'] }}
    - unless: systemctl status mssql-server

{% if 'tools' in salt['pillar.get']('db-mssql:packages') %}
db-mssql.pkg.tools:
  cmd.run:
    - name: apt-get install --assume-yes mssql-tools
    - env:
      - ACCEPT_EULA: Y
    - unless: grep 'accepteula = Y' /var/opt/mssql/mssql.conf
    - require:
      - pkgrepo: db-mssql.repo.microsoft
{% endif %}

{% if not salt['pillar.get']('db-mssql:defer_creation', False) %}
{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
{% if 'mssql' in platform %}
db-mssql.{{ domain }}.login:
  mssql_login.present:
    - name: {{ platform['mssql']['login']['name'] }}
    - new_login_password: {{ platform['mssql']['login']['password'] }}
    - user: sa
    - password: {{ pillar['db-mssql']['setup']['sa_password'] }}
    - require:
      - cmd: db-mssql.server.setup

db-mssql.{{ domain }}.database:
  mssql_database.present:
    - name: {{ platform['mssql']['database']['name'] }}
    - alter: {{ platform['mssql']['database'].get('alter', []) | yaml }}
    - new_database_options: {{ platform['mssql']['database'].get('options', []) | yaml }}
    - user: sa
    - password: {{ pillar['db-mssql']['setup']['sa_password'] }}
    - require:
      - cmd: db-mssql.server.setup

db-mssql.{{ domain }}.user:
  mssql_user.present:
    - name: {{ platform['mssql']['user']['name'] }}
    - login: {{ platform['mssql']['login']['name'] }}
    - database: {{ platform['mssql']['database']['name'] }}
    - roles: {{ platform['mssql']['user'].get('roles', []) | yaml }}
    - options: {{ platform['mssql']['user'].get('options', []) | yaml }}
    - user: sa
    - password: {{ pillar['db-mssql']['setup']['sa_password'] }}
    - require:
      - mssql_login: db-mssql.{{ domain }}.login
      - mssql_database: db-mssql.{{ domain }}.database
{% endif %}
{% endfor %}
{% endif %}

#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
{% set crontab = platform.get('crontab', {}) %}

{% for name, cron in crontab.get('crons', {}).items() %}
{% set minute, hour, daymonth, month, dayweek = cron['schedule'].split(' ') %}
app-crontab.{{ domain }}.cron.{{ name }}:
  cron.present:
    - identifier: app-crontab.{{ domain }}.cron.{{ name }}
    - name: {{ cron['command'] | yaml_squote }}
    - user: {{ platform['user']['name'] | yaml_squote }}
    - minute: {{ minute | yaml_squote }}
    - hour: {{ hour | yaml_squote }}
    - daymonth: {{ daymonth | yaml_squote }}
    - month: {{ month | yaml_squote }}
    - dayweek: {{ dayweek | yaml_squote }}
{% endfor %}

{% for variable, value in crontab.get('variables', {}).items() %}
app-crontab.{{ domain }}.variable.{{ variable }}:
  cron.env_present:
    - name: {{ variable | yaml_squote }}
    - user: {{ platform['user']['name'] | yaml_squote }}
    - value: {{ value | yaml_squote }}
{% endfor %}
{% endfor %}

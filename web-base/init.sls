#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% from 'web-base/map.sls' import web with context %}

include:
  - nginx

web.nginx.sites-extra:
  file.directory:
    - name: /etc/nginx/sites-extra
    - user: root
    - group: root
    - mode: 755

{% for home_directory in web.home_directories %}
web.homes.{{ home_directory }}:
  file.directory:
    - name: {{ home_directory }}
    - user: root
    - group: root
    - mode: 755

{% if pillar['acl']['apply'] %}
web.homes.{{ home_directory }}.acl:
  acl.present:
    - name: {{ home_directory }}
    - acl_type: user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: web.homes.{{ home_directory }}
{% endif %}
{% endfor %}

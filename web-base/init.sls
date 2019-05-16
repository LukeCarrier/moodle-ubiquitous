#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - nginx

web.nginx.sites-extra:
  file.directory:
    - name: /etc/nginx/sites-extra
    - user: root
    - group: root
    - mode: 755

{% for home_directory in pillar['system']['home_directories'] %}
web.homes.{{ home_directory }}:
  file.directory:
    - name: {{ home_directory }}
    - user: root
    - group: root
    - mode: 755

{% if pillar['acl']['apply'] %}
web.homes.acl:
  pkg.latest:
    - name: acl

web.homes.{{ home_directory }}.acl:
  acl.present:
    - name: {{ home_directory }}
    - acl_type: user
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rx
    - require:
      - file: web.homes.{{ home_directory }}
      - pkg: web.homes.acl
{% endif %}
{% endfor %}

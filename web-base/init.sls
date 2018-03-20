#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - nginx-base

web.nginx.sites-extra:
  file.directory:
    - name: /etc/nginx/sites-extra
    - user: root
    - group: root
    - mode: 755

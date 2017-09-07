#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

certbot.repo:
  pkgrepo.managed:
    - ppa: certbot/certbot
    - keyserver: http://keyserver.ubuntu.com

certbot.pkg:
  pkg.installed:
    - name: certbot
    - require:
      - pkgrepo: certbot.repo

# Work around Salt's acme execution module, whose __virtual__ function doesn't
# yet accommodate the letsencrypt-auto => certbot name change and doesn't
# instruct the CLI to run in a non-interactive state.
certbot.letsencrypt-auto:
  file.managed:
    - name: /usr/bin/letsencrypt-auto
    - source: salt://certbot/bin/letsencrypt-auto
    - user: root
    - group: root
    - mode: 0755

certbot.root:
  file.directory:
    - name: /var/www/acme
    - makedirs: True
    - user: {{ pillar['nginx']['user'] }}
    - group: {{ pillar['nginx']['user'] }}
    - mode: 0750

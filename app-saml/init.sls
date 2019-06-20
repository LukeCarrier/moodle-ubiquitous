#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @author Sascha Peter <sascha.o.peter@gmail.com>
# @copyright 2018 The Ubiquitous Authors
#

{% from 'php/macros.sls' import app_platform, app_restarts %}
{% from 'web-lets-encrypt/macros.sls' import lets_encrypt_all %}

include:
  - php
  - ubiquitous-cli-base

#
# SimpleSAMLphp platforms
#

{% for domain, platform in salt['pillar.get']('platforms', {}).items() if 'saml' in platform %}
{{ app_platform('saml', domain, platform) }}

app-saml.{{ domain }}.nginx.available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - source: salt://app-saml/nginx/platform.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: app-saml.nginx.restart
{% endif %}

app-saml.{{ domain }}.nginx.enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ platform['basename'] }}.conf
    - target: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - require:
      - file: app-saml.{{ domain }}.nginx.available
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: app-saml.nginx.restart
{% endif %}

{{ app_restarts('saml') }}

{{ lets_encrypt_all('saml', platforms) }}

#
# Ubiquitous Saml
#
# @author Sascha Peter <sascha.o.peter@gmail.com>
# @copyright 2017 Sascha Peter
#

include:
  - base
  - app-base

#
# OS software requirements
#

os.packages:
  pkg.installed:
  - pkgs:
    - libxml2
    - libxml2-dev
    - zlib1g
    - zlib1g-dev
    - openssl

{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
asso.{{ domain }}.nginx.available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - source: salt://app-saml/nginx/saml.nginx.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
      platform: {{ platform }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx
    - watch_in:
      - service: asso.nginx.reload

asso.{{ domain }}.nginx.enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ platform['basename'] }}.conf
    - target: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - require:
      - file: asso.{{ domain }}.nginx.available
{% if pillar['systemd']['apply'] %}
    - require_in:
      - service: nginx.reload
{% endif %}

# asso.{{ domain }}.saml.package:
  # archive.extracted:
  #   - name: {{ platform['user']['home'] }}/
  #   - source: https://github.com/simplesamlphp/simplesamlphp/releases/download/v1.14.14/simplesamlphp-1.14.14.tar.gz
  #   - source_hash: 2ff76d8b379141cdd3340dbd8e8bab1605e7a862d4a31657cc37265817463f48

# asso.{{ domain }}.saml.package.rename:
#   file.rename:
#     - name: {{ platform['user']['home'] }}/simplesamlphp
#     - source: {{ platform['user']['home'] }}/simplesamlphp-1.14.14
#     - force: true

asso.{{ domain }}.saml.config.replace:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/config/config.php
    - source: salt://app-saml/saml/config.php.jinja
    - template: jinja
    - context:
      platform: {{ platform }}
    - user: {{ platform['user']['name'] }}
    - group: {{ pillar['nginx']['user'] }}

{% if platform['saml']['role'] == 'idpp' %}
asso.{{ domain }}.saml.idpp.authsources.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/config/authsources.php
    - source: salt://app-saml/saml/idpproxy-authsources.php.jinja
    - template: jinja
    - context:
      platform: {{ platform }}
    - user: asso
    - group: www-data
    - mode: 0644

asso.{{ domain }}.saml.sp.cert.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/cert/sp.crt
    - contents_pillar: platforms:{{ domain }}:saml:sp_cert
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.sp.pem.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/cert/sp.pem
    - contents_pillar: platforms:{{ domain }}:saml:sp_pem
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.idp.cert.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/cert/server.crt
    - contents_pillar: platforms:{{ domain }}:saml:idp_cert
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.idp.pem.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/cert/server.pem
    - contents_pillar: platforms:{{ domain }}:saml:idp_pem
    - user: asso
    - group: www-data
    - mode: 0660
{% elif platform['saml']['role'] == 'idp' %}
asso.{{ domain }}.saml.authsources.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/config/authsources.php
    - source: salt://app-saml/saml/idp-authsources.php.jinja
    - template: jinja
    - context:
      platform: {{ platform }}
    - user: asso
    - group: www-data
    - mode: 0644

asso.{{ domain }}.saml.cert.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/cert/saml.crt
    - contents_pillar: platforms:{{ domain }}:saml:idp_cert
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.pem.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/cert/saml.pem
    - contents_pillar: platforms:{{ domain }}:saml:idp_pem
    - user: asso
    - group: www-data
    - mode: 0660
{% endif %}
{% endfor %}

asso.nginx.reload:
  service.running:
    - name: nginx
    - reload: true

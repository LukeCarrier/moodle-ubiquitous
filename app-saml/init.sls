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
    - php7.0-sqlite3
    - php7.0-gmp
    - libgmp-dev

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
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: app.nginx.restart
{% endif %}

asso.{{ domain }}.nginx.enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ platform['basename'] }}.conf
    - target: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - require:
      - file: asso.{{ domain }}.nginx.available
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: app.nginx.restart
{% endif %}

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

asso.{{ domain }}.saml.idpp.sp.cert.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/cert/sp.crt
    - contents_pillar: platforms:{{ domain }}:saml:sp_cert
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.idpp.sp.pem.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/cert/sp.pem
    - contents_pillar: platforms:{{ domain }}:saml:sp_pem
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.idpp.idp.cert.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/cert/server.crt
    - contents_pillar: platforms:{{ domain }}:saml:idp_cert
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.idpp.idp.pem.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/cert/server.pem
    - contents_pillar: platforms:{{ domain }}:saml:idp_pem
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.idp.metadata.idp-hosted.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/metadata/saml20-idp-hosted.php
    - contents_pillar: platforms:{{ domain }}:saml:meta_saml20_idp_hosted
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.idpp.metadata.idp-remote.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/metadata/saml20-idp-remote.php
    - contents_pillar: platforms:{{ domain }}:saml:meta_saml20_idp_remote
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.idpp.metadata.sp-remote.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/metadata/saml20-sp-remote.php
    - contents_pillar: platforms:{{ domain }}:saml:meta_saml20_sp_remote
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain}}.saml.idpp.redis.config.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/config/module_redis.php
    - contents_pillar: platforms:{{ domain }}:saml:config_redis
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.idpp.exampleauth.enable:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/modules/exampleauth/enable
    - source: None
    - user: asso
    - group: www-data
    - mode: 0644

asso.{{ domain }}.saml.idpp.redis.enable:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/modules/redis/enable
    - source: None
    - user: asso
    - group: www-data
    - mode: 0644

{% elif platform['saml']['role'] == 'idp' %}
asso.{{ domain }}.saml.idp.authsources.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/config/authsources.php
    - source: salt://app-saml/saml/idp-authsources.php.jinja
    - template: jinja
    - context:
      platform: {{ platform }}
    - user: asso
    - group: www-data
    - mode: 0644

asso.{{ domain }}.saml.idp.cert.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/cert/saml.crt
    - contents_pillar: platforms:{{ domain }}:saml:idp_cert
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.idp.pem.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/cert/saml.pem
    - contents_pillar: platforms:{{ domain }}:saml:idp_pem
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.idp.metadata.sp-remote.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/metadata/saml20-sp-remote.php
    - contents_pillar: platforms:{{ domain }}:saml:meta_saml20_sp_remote
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.idp.exampleauth.enable:
  file.managed:
    - name: {{ platform['user']['home'] }}/releases/simplesamlphp/modules/exampleauth/enable
    - source: None
    - user: asso
    - group: www-data
    - mode: 0644
{% endif %}
{% endfor %}

asso.nginx.reload:
  service.running:
    - name: nginx
    - reload: true

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

{% for domain, platform in salt['pillar.get']('platforms:saml_platforms', {}).items() %}
asso.{{ domain }}.user:
  user.present:
    - name: {{ platform['linux_user_username'] }}
    - fullname: {{ platform['linux_user_username'] }}
    - shell: /bin/bash
    - home: /home/{{ platform['linux_user_username'] }}
    - password: {{ platform['linux_user_password_hash'] }}
    - gid_from_name: true

asso.{{ domain }}.home:
  file.directory: 
    - name: /home/{{ platform['linux_user_username'] }}
    - user: {{ platform['linux_user_username'] }}
    - group: {{ platform['linux_user_username'] }}
    - mode: 0770
    - require:
      - user: {{ platform['linux_user_username'] }}

{% if pillar['acl']['apply'] %}
asso.{{ domain }}.home.acl:
  acl.present:
    - name: /home/{{ platform['linux_user_username'] }}
    - acl_type: user
    - acl_name: {{ platform['linux_user_username'] }}
    - perms: rx
    - require:
      - file: asso.{{ domain }}.home

asso.{{ domain }}.home.acl.default:
  acl.present:
    - name: /home/{{ platform['linux_user_username'] }}
    - acl_type: default:user
    - acl_name: {{ platform['linux_user_username'] }}
    - perms: rx
    - require:
      - file: asso.{{ domain }}.home
{% endif %}

asso.{{ domain }}.home.wwwuser:
  acl.present:
    - name: /home/{{ platform['linux_user_username'] }}
    - acl_type: group
    - acl_name: {{ pillar['nginx']['user'] }}
    - perms: rwx

asso.{{ domain }}.nginx.log:
  file.directory:
    - name: /var/log/nginx/asso
    - user: {{ pillar['nginx']['user'] }}
    - group: adm
    - mode: 0640

asso.{{ domain }}.nginx.available:
  file.managed:
    - name: /etc/nginx/sites-available/asso.conf
    - source: salt://app-saml/nginx/saml.nginx.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx

asso.{{ domain }}.saml.package:
  archive.extracted:
    - name: /home/{{ platform['linux_user_username'] }}/
    - source: https://github.com/simplesamlphp/simplesamlphp/releases/download/v1.14.14/simplesamlphp-1.14.14.tar.gz
    - source_hash: 2ff76d8b379141cdd3340dbd8e8bab1605e7a862d4a31657cc37265817463f48

asso.{{ domain }}.saml.package.rename:
  file.rename:
    - name: /home/{{ platform['linux_user_username'] }}/simplesamlphp
    - source: /home/{{ platform['linux_user_username'] }}/simplesamlphp-1.14.14
    - force: true

asso.{{ domain }}.saml.config.replace:
  file.managed:
    - name: /home/{{ platform['linux_user_username'] }}/simplesamlphp/config/config.php
    - source: salt://app-saml/saml/config.php.jinja
    - template: jinja
    - user: {{ platform['linux_user_username'] }}
    - group: {{ pillar['nginx']['user'] }}

asso.{{ domain }}.phpfpm.config.place:
  file.managed:
    - name: /etc/php/7.0/fpm/pools-available/sso.conf
    - source: salt://app-saml/php-fpm/sso.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

asso.{{ domain }}.nginx.symlink:
  file.symlink:
    - name: /etc/php/7.0/fpm/pools-enabled/sso.conf
    - target: /etc/php/7.0/fpm/pools-available/sso.conf

asso.{{ domain }}.phpfpm.symlink:
  file.symlink:
    - name: /etc/nginx/sites-enabled/asso.conf
    - target: /etc/nginx/sites-available/asso.conf

{% if domain == 'saml_idp_proxy' %}
asso.{{ domain }}.saml.idpp.authsources.place:
  file.managed:
    - name: /home/asso/simplesamlphp/config/authsources.php
    - source: salt://app-saml/saml/idpproxy-authsources.php.jinja
    - template: jinja
    - user: asso
    - group: www-data
    - mode: 0644

asso.{{ domain }}.saml.sp.cert.place:
  file.managed:
    - name: /home/asso/simplesamlphp/cert/sp.cert
    - source: salt://app-saml/certs/idpp-saml-sp.cert.jinja
    - template: jinja
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.sp.pem.place:
  file.managed:
    - name: /home/asso/simplesamlphp/cert/sp.pem
    - source: salt://app-saml/certs/idpp-saml-sp.pem.jinja
    - template: jinja
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.idp.cert.place:
  file.managed:
    - name: /home/asso/simplesamlphp/cert/idp.cert
    - source: salt://app-saml/certs/idpp-saml-idp.cert.jinja
    - template: jinja
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.idp.pem.place:
  file.managed:
    - name: /home/asso/simplesamlphp/cert/idp.pem
    - source: salt://app-saml/certs/idpp-saml-idp.pem.jinja
    - template: jinja
    - user: asso
    - group: www-data
    - mode: 0660
{% endif %}

{% if domain == 'saml_identity_provider' %}
asso.{{ domain }}.saml.authsources.place:
  file.managed:
    - name: /home/asso/simplesamlphp/config/authsources.php
    - source: salt://app-saml/saml/idp-authsources.php.jinja
    - template: jinja
    - user: asso
    - group: www-data
    - mode: 0644

asso.{{ domain }}.saml.cert.place:
  file.managed:
    - name: /home/asso/simplesamlphp/cert/saml.cert
    - source: salt://app-saml/certs/idp-saml.cert.jinja
    - template: jinja
    - user: asso
    - group: www-data
    - mode: 0660

asso.{{ domain }}.saml.pem.place:
  file.managed:
    - name: /home/asso/simplesamlphp/cert/saml.pem
    - source: salt://app-saml/certs/idp-saml.pem.jinja
    - template: jinja
    - user: asso
    - group: www-data
    - mode: 0660
{% endif %}

asso.{{ domain }}.phpfpm.reload:
  service.running:
    - name: php7.0-fpm

asso.{{ domain }}.nginx.reload:
  service.running:
    - name: nginx
{% endfor %}

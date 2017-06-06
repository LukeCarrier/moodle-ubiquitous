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

asso.user:
  user.present:
    - name: {{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}
    - fullname: {{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}
    - shell: /bin/bash
    - home: /home/{{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}
    - password: {{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_password_hash'] }}
    - gid_from_name: true

asso.home:
  file.directory: 
    - name: /home/{{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}
    - user: {{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}
    - group: {{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}
    - mode: 0770
    - require:
      - user: {{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}

{% if pillar['acl']['apply'] %}
asso.home.acl:
  acl.present:
    - name: /home/{{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}
    - acl_type: user
    - acl_name: {{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}
    - perms: rx
    - require:
      - file: asso.home

asso.home.acl.default:
  acl.present:
    - name: /home/{{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}
    - acl_type: default:user
    - acl_name: {{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}
    - perms: rx
    - require:
      - file: asso.home
{% endif %}

asso.nginx.log:
  file.directory:
    - name: /var/log/nginx/asso
    - user: {{ pillar['nginx']['user'] }}
    - group: adm
    - mode: 0640

asso.nginx.available:
  file.managed:
    - name: /etc/nginx/sites-available/asso.conf
    - source: salt://app-saml/nginx/saml.nginx.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx

asso.saml.package:
  archive.extracted:
    - name: /home/{{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}/
    - source: https://github.com/simplesamlphp/simplesamlphp/releases/download/v1.14.14/simplesamlphp-1.14.14.tar.gz
    - source_hash: 2ff76d8b379141cdd3340dbd8e8bab1605e7a862d4a31657cc37265817463f48

asso.saml.package.rename:
  file.rename:
    - name: /home/{{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}/simplesamlphp
    - source: /home/{{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}/simplesamlphp-1.14.14
    - force: true

asso.saml.config.replace:
  file.managed:
    - name: /home/{{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}/simplesamlphp/config.php
    - source: salt://app-saml/saml/config.php.jinja
    - template: jinja
    - user: {{ pillar['platforms']['saml_platforms']['saml_idp_proxy']['linux_user_username'] }}
    - group: {{ pillar['nginx']['user'] }}

asso.phpfpm.config.place:
  file.managed:
    - name: /etc/php/7.0/fpm/pools-available/sso.conf
    - source: salt://app-saml/php-fpm/sso.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

asso.phpfpm.reload:
  service.running:
    - name: php7.0-fpm
    - reload: True

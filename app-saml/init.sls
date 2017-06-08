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

{% for platform, configuration in salt['pillar.get']('platforms:saml_platforms', {}).items() %}
asso.user:
  user.present:
    - name: {{ configuration['linux_user_username'] }}
    - fullname: {{ configuration['linux_user_username'] }}
    - shell: /bin/bash
    - home: /home/{{ configuration['linux_user_username'] }}
    - password: {{ configuration['linux_user_password_hash'] }}
    - gid_from_name: true

asso.home:
  file.directory: 
    - name: /home/{{ configuration['linux_user_username'] }}
    - user: {{ configuration['linux_user_username'] }}
    - group: {{ configuration['linux_user_username'] }}
    - mode: 0770
    - require:
      - user: {{ configuration['linux_user_username'] }}

{% if configuration['acl']['apply'] %}
asso.home.acl:
  acl.present:
    - name: /home/{{ configuration['linux_user_username'] }}
    - acl_type: user
    - acl_name: {{ configuration['linux_user_username'] }}
    - perms: rx
    - require:
      - file: asso.home

asso.home.acl.default:
  acl.present:
    - name: /home/{{ configuration['linux_user_username'] }}
    - acl_type: default:user
    - acl_name: {{ configuration['linux_user_username'] }}
    - perms: rx
    - require:
      - file: asso.home
{% endif %}

asso.home.wwwuser:
  acl.present:
    - name: /home/{{ configuration['linux_user_username'] }}
    - acl_type: group
    - acl_name: {{ configuration['nginx']['user'] }}
    - perms: rwx

asso.nginx.log:
  file.directory:
    - name: /var/log/nginx/asso
    - user: {{ configuration['nginx']['user'] }}
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
    - name: /home/{{ configuration['linux_user_username'] }}/
    - source: https://github.com/simplesamlphp/simplesamlphp/releases/download/v1.14.14/simplesamlphp-1.14.14.tar.gz
    - source_hash: 2ff76d8b379141cdd3340dbd8e8bab1605e7a862d4a31657cc37265817463f48

asso.saml.package.rename:
  file.rename:
    - name: /home/{{ configuration['linux_user_username'] }}/simplesamlphp
    - source: /home/{{ configuration['linux_user_username'] }}/simplesamlphp-1.14.14
    - force: true

asso.saml.config.replace:
  file.managed:
    - name: /home/{{ configuration['linux_user_username'] }}/simplesamlphp/config/config.php
    - source: salt://app-saml/saml/config.php.jinja
    - template: jinja
    - user: {{ configuration['linux_user_username'] }}
    - group: {{ pillar['nginx']['user'] }}

asso.phpfpm.config.place:
  file.managed:
    - name: /etc/php/7.0/fpm/pools-available/sso.conf
    - source: salt://app-saml/php-fpm/sso.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

asso.nginx.symlink:
  file.symlink:
    - name: /etc/php/7.0/fpm/pools-enabled/sso.conf
    - target: /etc/php/7.0/fpm/pools-available/sso.conf

asso.phpfpm.symlink:
  file.symlink:
    - name: /etc/nginx/sites-enabled/asso.conf
    - target: /etc/nginx/sites-available/asso.conf

{% if platform == 'saml_idp_proxy' %}
asso.phpfpm.config.place:
  file.managed:
    - name: /home/asso/simplesamlphp/config/authsources.php
    - source: salt://app-saml/saml/idpproxy-authsources.php.jinja
    - template: jinja
    - user: asso
    - group: www-data
    - mode: 0644
{% endif %}

{% if platform == 'saml_identity_provider' %}
asso.phpfpm.config.place:
  file.managed:
    - name: /home/asso/simplesamlphp/config/authsources.php
    - source: salt://app-saml/saml/idp-authsources.php.jinja
    - template: jinja
    - user: asso
    - group: www-data
    - mode: 0644
{% endif %}

asso.phpfpm.reload:
  service.running:
    - name: php7.0-fpm

asso.nginx.reload:
  service.running:
    - name: nginx
{% endfor %}

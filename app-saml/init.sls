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
    - name: asso
    - fullname: asso
    - shell: /bin/bash
    - home: /home/asso
    - gid_from_name: true

asso.home:
  file.directory: 
    - name: /home/asso
    - user: asso
    - group: asso
    - mode: 0770
    - require:
      - user: asso

{% if pillar['acl']['apply'] %}
asso.home.acl:
  acl.present:
    - name: /home/asso
    - acl_type: user
    - acl_name: asso
    - perms: rx
    - require:
      - file: asso.home

asso.home.acl.default:
  acl.present:
    - name: /home/asso
    - acl_type: default:user
    - acl_name: asso
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
    - source: salt://app-saml/nginx/asso.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx

asso.saml.package:
  archive.extracted:
    - name: /home/asso/
    - source: https://github.com/simplesamlphp/simplesamlphp/releases/download/v1.14.14/simplesamlphp-1.14.14.tar.gz
    - source_hash: 2ff76d8b379141cdd3340dbd8e8bab1605e7a862d4a31657cc37265817463f48

asso.saml.package.rename:
  file.rename:
    - name: /home/asso/simplesamlphp
    - source: /home/asso/simplesamlphp-1.14.14
    - require:
      - pkg: asso.saml.package

asso.saml.config.replace:
  file.managed:
    - name: /home/asso/simplesamlphp/config
    - source: salt://app-saml/saml/config.php.jinja
    - template: jinja
    - user: root
    - group: root
    - require:
      - pkg: asso.saml.package.rename

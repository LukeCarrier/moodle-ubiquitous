#
# The Perfect Cluster: Moodle
#
# @author Luke Carrier <luke.carrier@floream.com>
# @copyright 2015 Floream Limited
#

#
# EPEL release
#

epel-release:
  pkg:
    - installed
    - allow_updates: True
    - sources:
      - epel-release: https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

#
# Webtatic package repository
#

webtatic-release:
  pkg:
    - installed
    - allow_updates: True
    - sources:
      - webtatic-release: https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

#
# HTTP server
#

nginx-release-centos:
  pkg:
    - installed
    - allow_updates: True
    - sources:
      - nginx-release-centos: http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

nginx:
  pkg.installed:
    - require:
      - pkg: nginx-release-centos
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: nginx
      - file: /etc/nginx/conf.d/moodle.conf

#
# PHP
#

php.packages:
  pkg.installed:
    - pkgs:
      - php56w
      - php56w-cli
      - php56w-fpm
      - php56w-gd
      - php56w-intl
      - php56w-mbstring
      - php56w-opcache
      - php56w-pdo
      - php56w-pgsql
      - php56w-soap
      - php56w-xml
      - php56w-xmlrpc

/etc/php-fpm.d/www.conf:
  file.absent: []

/etc/php-fpm.d/moodle.conf:
  file.managed:
    - source: salt://app/php-fpm/moodle.conf
    - owner: root
    - group: root
    - mode: 0644
    - require:
      - pkg: php.packages

php-fpm:
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: nginx
      - pkg: php.packages
      - file: /etc/php-fpm.d/moodle.conf

#
# Firewall
#

public:
  firewalld.present:
    - services:
      - http
      - ssh

#
# SELinux
#

httpd_read_user_content:
  selinux.boolean:
    - value: True
    - persist: True

#
# Moodle
#

moodle:
  user.present:
    - fullname: Moodle user
    - shell: /bin/bash
    - home: /home/moodle
    - uid: 1001
    - gid_from_name: true

/etc/nginx/conf.d/default.conf:
  file.absent: []

/etc/nginx/conf.d/moodle.conf:
  file.managed:
    - source: salt://app/nginx/moodle.conf
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx

/home:
  acl.present:
    - acl_type: user
    - acl_name: nginx
    - perms: rx

/home/moodle:
  acl.present:
    - acl_type: user
    - acl_name: nginx
    - perms: rx

/home/moodle/htdocs:
  file.directory:
    - user: moodle
    - group: moodle
    - mode: 0750
  acl.present:
    - acl_type: user
    - acl_name: nginx
    - perms: rx
    - recurse: True

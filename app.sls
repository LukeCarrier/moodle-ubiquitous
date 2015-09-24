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
    - require:
      - pkg: nginx

#
# PHP
#

php.packages:
  pkg.installed:
    - pkgs:
      - php56w
      - php56w-cli
      - php56w-gd
      - php56w-intl
      - php56w-mbstring
      - php56w-opcache
      - php56w-pdo
      - php56w-pgsql
      - php56w-soap
      - php56w-xml
      - php56w-xmlrpc

#
# Firewall
#

public:
  firewalld.present:
    - services:
      - http
      - ssh


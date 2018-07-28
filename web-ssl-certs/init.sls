#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - nginx-base

web-ssl-certs.dir:
  file.directory:
    - name: /etc/nginx/ssl
    - user: root
    - group: root
    - mode: 0700
    - require:
      - nginx

{% for domain, platform in salt['pillar.get']('platforms').items() if 'ssl' in platform %}
{% for certificate_domain, parts in platform['ssl'].items() %}
web-ssl-certs.{{ certificate_domain }}.public:
  file.managed:
    - name: /etc/nginx/ssl/{{ certificate_domain }}.crt
    - contents_pillar: platforms:{{ domain }}:ssl:{{ certificate_domain }}:public
    - user: root
    - group: root
    - mode: 0600
    - require:
      - web-ssl-certs.dir

web-ssl-certs.{{ certificate_domain }}.private:
  file.managed:
    - name: /etc/nginx/ssl/{{ certificate_domain }}.pem
    - contents_pillar: platforms:{{ domain }}:ssl:{{ certificate_domain }}:private
    - user: root
    - group: root
    - mode: 0600
    - require:
      - web-ssl-certs.dir
{% endfor %}
{% endfor %}

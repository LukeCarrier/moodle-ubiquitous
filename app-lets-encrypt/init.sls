#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - app-base
  - certbot

{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
{% if 'lets_encrypt' in platform %}
app-lets-encrypt.{{ domain }}.nginx-acme-challenge:
  file.managed:
    - name: /etc/nginx/sites-extra/{{ platform['basename'] }}.lets-encrypt.conf
    - source: salt://app-lets-encrypt/nginx/platform.lets-encrypt.conf
    - user: root
    - group: root
    - mode: 0644
    - require:
      - file: certbot.acme-challenge-snippet
    - watch_in:
      - service: app-lets-encrypt.nginx-pre-certbot

app-lets-encrypt.{{ domain }}.cert:
  acme.cert:
    - name: {{ domain }}
    - email: {{ platform['lets_encrypt']['email'] }}
    - webroot: /var/www/acme
    - renew: {{ platform['lets_encrypt']['lifetime'] }}
    {% if platform['lets_encrypt']['test_cert'] %}
    - test_cert: true
    {% endif %}
    - require:
      - pkg: certbot.pkg
      - file: certbot.root
      - file: app-lets-encrypt.{{ domain }}.nginx-acme-challenge
      - service: app-lets-encrypt.nginx-pre-certbot
    - watch_in:
      - service: app-lets-encrypt.nginx-post-certbot
{% endif %}
{% endfor %}

app-lets-encrypt.nginx-pre-certbot:
  cmd.run:
    - name: systemctl reload nginx || systemctl restart nginx

app-lets-encrypt.nginx-post-certbot:
  cmd.run:
    - name: systemctl restart nginx

{% macro lets_encrypt_platform(app, domain, platform) %}
{% if 'lets_encrypt' in platform and platform['lets_encrypt']['enabled'] %}
web-{{ app }}-lets-encrypt.{{ domain }}.nginx-acme-challenge:
  file.managed:
    - name: /etc/nginx/sites-extra/{{ platform['basename'] }}.lets-encrypt.conf
    - source: salt://web-lets-encrypt/nginx/platform.lets-encrypt.conf
    - user: root
    - group: root
    - mode: 0644
    - onchanges_in:
      - web-{{ app }}-lets-encrypt.nginx-pre-certbot

web-{{ app }}-lets-encrypt.{{ domain }}.cert:
  acme.cert:
    - name: {{ domain }}
    - email: {{ platform['lets_encrypt']['email'] }}
    - webroot: /var/www/acme
    - renew: {{ platform['lets_encrypt']['lifetime'] }}
    - test_cert: {{ platform['lets_encrypt']['test_cert'] }}
    - require:
      - web-{{ app }}-lets-encrypt.{{ domain }}.nginx-acme-challenge
      - web-{{ app }}-lets-encrypt.nginx-pre-certbot
    - onchanges_in:
      - web-{{ app }}-lets-encrypt.nginx-post-certbot
{% endif %}
{% endmacro %}

{% macro lets_encrypt_restarts(app) %}
web-{{ app }}-lets-encrypt.nginx-pre-certbot:
  cmd.run:
    - name: systemctl reload nginx || systemctl restart nginx
  onchanges:
    - web-{{ app }}-null

web-{{ app }}-lets-encrypt.nginx-post-certbot:
  cmd.run:
    - name: systemctl restart nginx
  onchanges:
    - web-{{ app }}-null
{% endmacro %}

{% macro lets_encrypt_all(app, platforms) %}
{% for domain, platform in salt['pillar.get']('platforms', {}).items() if 'lets_encrypt' in platform %}
{{ lets_encrypt_platform(app, domain, platform) }}

{% if loop.last %}
{{ lets_encrypt_restarts(app) }}
{% endif %}
{% endfor %}
{% endmacro %}

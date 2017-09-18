{% macro lets_encrypt_platform(app, domain, platform) %}
{% if 'lets_encrypt' in platform and platform['lets_encrypt']['enabled'] %}
app-{{ app }}-lets-encrypt.{{ domain }}.nginx-acme-challenge:
  file.managed:
    - name: /etc/nginx/sites-extra/{{ platform['basename'] }}.lets-encrypt.conf
    - source: salt://app-lets-encrypt/nginx/platform.lets-encrypt.conf
    - user: root
    - group: root
    - mode: 0644
    - onchanges_in:
      - app-{{ app }}-lets-encrypt.nginx-pre-certbot

app-{{ app }}-lets-encrypt.{{ domain }}.cert:
  acme.cert:
    - name: {{ domain }}
    - email: {{ platform['lets_encrypt']['email'] }}
    - webroot: /var/www/acme
    - renew: {{ platform['lets_encrypt']['lifetime'] }}
    - test_cert: {{ platform['lets_encrypt']['test_cert'] }}
    - require:
      - app-{{ app }}-lets-encrypt.{{ domain }}.nginx-acme-challenge
      - app-{{ app }}-lets-encrypt.nginx-pre-certbot
    - onchanges_in:
      - app-{{ app }}-lets-encrypt.nginx-post-certbot
{% endif %}
{% endmacro %}

{% macro lets_encrypt_restarts(app) %}
app-{{ app }}-lets-encrypt.nginx-pre-certbot:
  cmd.run:
    - name: systemctl reload nginx || systemctl restart nginx
  onchanges:
    - app-{{ app }}-null

app-{{ app }}-lets-encrypt.nginx-post-certbot:
  cmd.run:
    - name: systemctl restart nginx
  onchanges:
    - app-{{ app }}-null
{% endmacro %}

{% macro lets_encrypt_all(app, platforms) %}
{% for domain, platform in salt['pillar.get']('platforms', {}).items() if 'lets_encrypt' in platform %}
{{ lets_encrypt_platform(app, domain, platform) }}

{% if loop.last %}
{{ lets_encrypt_restarts(app) }}
{% endif %}
{% endfor %}
{% endmacro %}

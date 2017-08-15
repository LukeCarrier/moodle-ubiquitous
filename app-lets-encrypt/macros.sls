{% macro lets_encrypt_platform(app, domain, platform) %}
{% if 'lets_encrypt' in platform %}
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

app-{{ app }}-lets-encrypt.nginx-post-certbot:
  cmd.run:
    - name: systemctl restart nginx
{% endmacro %}

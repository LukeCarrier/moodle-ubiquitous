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
    - php7.0-sqlite3
    - php7.0-gmp
    - libgmp-dev

{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}

{% if 'lets_encrypt' in platform %}
# TODO: This needs refactoring not to import the macro's for every platform/domain.
{% from 'app-lets-encrypt/macros.sls'
    import lets_encrypt_platform, lets_encrypt_restarts %}
{% endif %}

asso.{{ domain }}.nginx.available:
  file.managed:
    - name: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - source: salt://app-saml/nginx/platform.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
      platform: {{ platform }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: app.nginx.restart
{% endif %}

asso.{{ domain }}.nginx.enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{ platform['basename'] }}.conf
    - target: /etc/nginx/sites-available/{{ platform['basename'] }}.conf
    - require:
      - file: asso.{{ domain }}.nginx.available
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: app.nginx.restart
{% endif %}

{{ platform['user']['home'] }}/conf/config:
  file.directory:
    - user: {{ platform['user']['name'] }}
    - group: {{ pillar['nginx']['user'] }}
    - mode: 0770
    - makedirs: True

{{ platform['user']['home'] }}/conf/cert:
  file.directory:
    - user: {{ platform['user']['name'] }}
    - group: {{ pillar['nginx']['user'] }}
    - mode: 0770

{{ platform['user']['home'] }}/conf/metadata:
  file.directory:
    - user: {{ platform['user']['name'] }}
    - group: {{ pillar['nginx']['user'] }}
    - mode: 0770

{{ platform['user']['home'] }}/conf/modules:
  file.directory:
    - user: {{ platform['user']['name'] }}
    - group: {{ pillar['nginx']['user'] }}
    - mode: 0770

{% for file, value in platform['saml']['config'].items() %}
asso.{{ domain }}.saml.{{ platform['saml']['role'] }}.config.{{ file }}.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/conf/config/{{ file }}
    - contents_pillar: platforms:{{ domain }}:saml:config:{{ file }}
    - user: {{ platform['user']['name'] }}
    - group: {{ pillar['nginx']['user'] }}
    - mode: 0644
{% endfor %}

{% for module, status in platform['saml']['modules'].items() %}
{% if status %}
asso.{{ domain }}.saml.{{ platform['saml']['role'] }}.{{ module }}.enable:
  file.managed:
    - name: {{ platform['user']['home'] }}/conf/modules/{{ module }}/enable
    - user: {{ platform['user']['name'] }}
    - group: {{ pillar['nginx']['user'] }}
    - mode: 0644
    - makedirs: True
{% else %}
asso.{{ domain }}.saml.{{ platform['saml']['role'] }}.{{ module }}.disable:
  file.absent:
    - name: {{ platform['user']['home'] }}/conf/modules/{{ module }}/enable
{% endif %}
{% endfor %}

{% for file, value in platform['saml']['cert'].items() %}
asso.{{ domain }}.saml.{{ platform['saml']['role'] }}.cert.{{ file }}.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/conf/cert/{{ file }}
    - contents_pillar: platforms:{{ domain }}:saml:cert:{{ file }}
    - user: {{ platform['user']['name'] }}
    - group: {{ pillar['nginx']['user'] }}
    - mode: 0660
{% endfor %}

{% for file, value in platform['saml']['metadata'].items() %}
asso.{{ domain }}.saml.{{ platform['saml']['role'] }}.metadata.{{ file }}.place:
  file.managed:
    - name: {{ platform['user']['home'] }}/conf/metadata/{{ file }}
    - contents_pillar: platforms:{{ domain }}:saml:metadata:{{ file }}
    - user: {{ platform['user']['name'] }}
    - group: {{ pillar['nginx']['user'] }}
    - mode: 0660
{% endfor %}

{% if 'lets_encrypt' in platform %}
{{ lets_encrypt_platform('saml', domain, platform) }}
{{ lets_encrypt_restarts('saml') }}
{% endif %}
{% endfor %}

asso.nginx.reload:
  service.running:
    - name: nginx
    - reload: true



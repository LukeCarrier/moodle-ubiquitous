#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% from 'postfix/macros.sls' import postfix_debconf_option, postfix_normalise_main_option %}

{# Map of main.cf directives to debconf options and vice versa #}
{% set main_debconf_map = {
  'mydestination': 'destinations',
} %}
{% set debconf_main_map = {
  'destinations': 'mydestination',
} %}

{# debconf option formatting rules #}
{% set debconf_props = {
  'chattr': {
    'type': 'boolean',
  },
} %}

{# Postfix option formatting rules #}
{% set main_props = {
  'mydestination': {
    'delimiter': ', ',
  },
  'mynetworks': {
    'delimiter': ' ',
  },
  'smtpd_relay_restrictions': {
    'delimiter': ', ',
  },
} %}

postfix.pkgs:
  pkg.latest:
    - pkgs:
      - libsasl2-modules
      - postfix
    - require:
      - debconf: postfix.debconf

{% if 'debconf' in salt['pillar.get']('postfix', {}) %}
postfix.debconf:
  debconf.set:
    - name: postfix
    - data:
  {% for name, value in salt['pillar.get']('postfix:debconf', {}).items() %}
    {{ postfix_debconf_option(name, debconf_main_map, debconf_props, main_props, value) }}
  {% endfor %}
{% endif %}


{% for name, value in salt['pillar.get']('postfix:main', {}).items() %}
  {% if name in main_debconf_map %}
    {% set debconf_name = main_debconf_map[name] %}
postfix.debconf.{{ debconf_name }}:
  debconf.set:
    - name: postfix
    - data:
    {{ postfix_debconf_option(debconf_name, debconf_main_map, debconf_props, main_props, value) }}
  {% endif %}
{% endfor %}

{% if 'main' in salt['pillar.get']('postfix', {}) %}
postfix.main:
  postfix.set_main:
    - values:
  {% for name, value in pillar['postfix']['main'].items() %}
        {{ name }}: {{ postfix_normalise_main_option(name, main_props.get(name, {}), value) }}
  {% endfor %}
    - onchanges_in:
      - cmd: postfix.reload
{% endif %}

{% if 'sasl_passwords' in pillar.get('postfix', {}) %}
postfix.sasl-passwords.source:
  file.managed:
    - name: /etc/postfix/sasl_passwd
    - source: salt://postfix/postfix/sasl_passwd.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0600

postfix.sasl-passwords.postmap:
  cmd.run:
    - name: postmap /etc/postfix/sasl_passwd
    - onchanges:
      - file: postfix.sasl-passwords.source
    - onchanges_in:
      - cmd: postfix.reload
{% endif %}

postfix.reload:
  cmd.run:
    - name: systemctl restart postfix

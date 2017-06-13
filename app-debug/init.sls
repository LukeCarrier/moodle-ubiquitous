#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - app

app-debug.php.xdebug:
  pkg.installed:
    - pkgs:
      - php-xdebug

{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
{% set behat_faildump = platform['user']['home'] + '/data/behat-faildump' %}
app-debug.{{ domain }}.behat-faildump:
  file.directory:
  - name: {{ behat_faildump }}
  - user: {{ platform['user']['name'] }}
  - group: {{ platform['user']['name'] }}
  - mode: 0770

{% if pillar['acl']['apply'] %}
app-debug.{{ domain }}.behat-faildump.acl:
  acl.present:
  - name: {{ behat_faildump }}
  - acl_type: user
  - acl_name: {{ pillar['nginx']['user'] }}
  - perms: rx
  - require:
    - app-debug.{{ domain }}.behat-faildump
{% endif %}

app-debug.{{ domain }}.php-fpm:
  file.managed:
    - name: /etc/php/7.0/fpm/pools-extra/{{ platform['basename'] }}.debug.conf
    - source: salt://app-debug/php-fpm/platform.debug.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
    - user: root
    - group: root
    - mode: 0644
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - app-debug.php-fpm.reload
{% endif %}

app-debug.{{ domain }}.nginx:
  file.managed:
    - name: /etc/nginx/sites-extra/{{ platform['basename'] }}.debug.conf
    - source: salt://app-debug/nginx/platform.debug.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
    - user: root
    - group: root
    - mode: 0644
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - app-debug.nginx.reload
{% endif %}
{% endfor %}

{% if pillar['systemd']['apply'] %}
app-debug.nginx.reload:
  cmd.run:
    - name: systemctl reload nginx || systemctl restart nginx

app-debug.php-fpm.reload:
  cmd.run:
    - name: systemctl reload php7.0-fpm || systemctl restart php7.0-fpm
{% endif %}

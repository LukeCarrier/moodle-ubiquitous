#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

php.xdebug:
  pkg.installed:
    - pkgs:
      - php-xdebug

{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
{{ platform['user']['home'] }}/data/behat-faildump:
  file.directory:
  - user: {{ platform['user']['name'] }}
  - group: {{ platform['user']['name'] }}
  - mode: 0770

{% if pillar['acl']['apply'] %}
{{ platform['user']['home'] }}/data/behat-faildump.acl:
  acl.present:
  - name: {{ platform['user']['home'] }}/data/behat-faildump
  - acl_type: user
  - acl_name: nginx
  - perms: rx
  - require:
    - file: {{ platform['user']['home'] }}/data/behat-faildump
{% endif %}

/etc/php/7.0/fpm/pools-extra/{{ platform['basename'] }}.debug.conf:
  file.managed:
    - source: salt://app-debug/php-fpm/platform.debug.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
      platform: {{ platform }}
    - user: root
    - group: root
    - mode: 0644

/etc/nginx/sites-extra/{{ platform['basename'] }}.debug.conf:
  file.managed:
    - source: salt://app-debug/nginx/platform.debug.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
      platform: {{ platform }}
    - user: root
    - group: root
    - mode: 0644
{% endfor %}

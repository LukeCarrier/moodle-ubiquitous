#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - app-base

{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
{% if 'default_release' in platform %}
{% set release_dir = platform['user']['home'] + '/releases/' + platform['default_release'] %}

app-default-release.{{ domain }}.release:
  file.directory:
    - name: {{ release_dir }}
    - user: {{ platform ['user']['name'] }}
    - group: {{ platform ['user']['name'] }}
    - mode: 0755
    - require:
      - file: app.{{ domain }}.releases

app-default-release.{{ domain }}.current:
  file.symlink:
    - name: {{ platform['user']['home'] }}/current
    - target: {{ release_dir }}
    - user: {{ platform['user']['name'] }}
    - group: {{ platform['user']['name'] }}
    - require:
      - file: app-default-release.{{ domain }}.release
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - cmd: app-default-release.php-fpm.reload
{% endif %}

app-default-release.{{ domain }}.php-fpm.blue:
  file.symlink:
    - name: /etc/php/7.0/fpm/pools-enabled/{{ platform['basename'] }}.blue.conf
    - target: /etc/php/7.0/fpm/pools-available/{{ platform['basename'] }}.blue.conf
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - cmd: app-default-release.php-fpm.reload
{% endif %}

app-default-release.{{ domain }}.php-fpm.green:
  file.absent:
    - name: /etc/php/7.0/fpm/pools-available/{{ platform['basename'] }}.green.conf
{% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - cmd: app-default-release.php-fpm.reload
{% endif %}
{% endif %}
{% endfor %}

{% if pillar['systemd']['apply'] %}
app-default-release.php-fpm.reload:
  cmd.run:
    - name: systemctl reload php7.0-fpm || systemctl restart php7.0-fpm
{% endif %}

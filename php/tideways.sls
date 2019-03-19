include:
  - php

app-tideways.repo:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/tideways.list
    - humanname: Tideways
    - name: deb http://s3-eu-west-1.amazonaws.com/tideways/packages debian main
    - keyserver: hkp://pool.sks-keyservers.net:80
    - keyid: EEB5E8F4

app-tideways.pkgs:
  pkg.installed:
    - pkgs:
      - tideways-daemon
      - tideways-php

{% for domain, platform in salt['pillar.get']('platforms', {}).items() if 'tideways' in platform %}
  {% if pillar['systemd']['apply'] and reload_printed is not defined %}
app-tideways.php-fpm.reload:
  cmd.run:
    - name: systemctl reload php{{ platform.php.version }}-fpm || systemctl restart php{{ platform.php.version }}-fpm
    {% set reload_printed = True %}
  {% endif %}

app-tideways.{{ domain }}.php-fpm:
  file.managed:
    - name: /etc/php/{{ platform.php.version }}/fpm/pools-extra/{{ platform['basename'] }}.tideways.conf
    - source: salt://app-tideways/php-fpm/platform.tideways.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
    - user: root
    - group: root
    - mode: 0644
    - onchanges_in:
      - cmd: app-tideways.php-fpm.reload
{% endfor %}

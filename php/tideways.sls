include:
  - php
  - tideways.daemon

{% for domain, platform in salt['pillar.get']('platforms', {}).items() if 'tideways' in platform %}
  {% if pillar['systemd']['apply'] and reload_printed is not defined %}
php.tideways.php-fpm.reload:
  cmd.run:
    - name: systemctl reload php{{ platform.php.version }}-fpm || systemctl restart php{{ platform.php.version }}-fpm
    {% set reload_printed = True %}
  {% endif %}

php.tideways.{{ domain }}.php-fpm:
  file.managed:
    - name: /etc/php/{{ platform.php.version }}/fpm/pools-extra/{{ platform['basename'] }}.tideways.conf
    - source: salt://php/php-fpm/platform.tideways.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
    - user: root
    - group: root
    - mode: 0644
    - onchanges_in:
      - cmd: php.tideways.php-fpm.reload
{% endfor %}

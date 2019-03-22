{% from 'php/map.jinja' import php with context %}
{% from 'php/macros.sls' import php_pecl_extension, php_extension_available, php_extension_enabled %}

include:
  - php

{% for version in php.versions.keys() %}
{{ php_pecl_extension(version, 'igbinary') }}
{{ php_extension_available(version, 'igbinary', 20) }}
  {% for sapi in ['cli', 'fpm'] %}
{{ php_extension_enabled(version, sapi, 'igbinary', 20) }}
      {% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - service: php.{{ version }}.fpm.restart
      {% endif %}
  {% endfor %}
{% endfor %}

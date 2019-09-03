{% from 'admin/map.jinja' import admin with context %}

{% if 'locales' in admin %}
admin.locales.pkgs:
  pkg.latest:
    - pkgs: {{ admin.locales.packages | yaml }}

  {% for locale in admin.locales.get('present', []) %}
admin.locales.present.{{ locale }}:
  locale.present:
    - name: {{ locale }}
    - require:
      - pkg: admin.locales.pkgs
  {% endfor %}

  {% if 'default' in admin.locales %}
admin.locales.default:
  locale.system:
    - name: {{ admin.locales.default }}
  {% endif %}
{% endif %}

{%- macro postfix_normalise_main_option(name, props, value) -%}
  {%- if 'delimiter' in props -%}
    {%- set value = value | join(props['delimiter']) -%}
  {%- elif 'type' in props and props['type'] == 'bool' -%}
    {%- set value = 'yes' if value else 'no' -%}
  %}
  {%- endif -%}
  {{- value | json -}}
{%- endmacro -%}

{% macro postfix_debconf_option(name, debconf_main_map, debconf_props, main_props, value) %}
  {% set debconf_props = debconf_props.get(name, {
    'type': 'string',
  }) %}
  {% set main_props = main_props.get(debconf_main_map.get(name, ''), {}) %}
        postfix/{{ name }}:
          type: {{ debconf_props['type'] }}
          value: {{ postfix_normalise_main_option(name, main_props, value) }}
{% endmacro %}

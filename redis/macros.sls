#
# Ubiquitous Redis
#
# @author Sascha Peter <sascha.o.peter@gmail.com>
# @copyright 2018 The Ubiquitous Authors
#

{%- macro redis_config_option(key, value) -%}
{%-   if value is string -%}
{%-     if value == '' -%}
{{ key }} ''
{%-     else -%}
{{ key }} {{ value }}
{%-     endif -%}
{%-   elif value is sameas False or value is sameas True -%}
{{ key }} {{ 'yes' if value else 'no' }}
{%-   elif value is iterable and value | length > 0 -%}
{%-     for single_value in value %}
{{ key }} {{ single_value }}
{%-     endfor -%}
{%-   endif -%}
{%- endmacro -%}

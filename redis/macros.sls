#
# Ubiquitous Redis
#
# @author Sascha Peter <sascha.o.peter@gmail.com>
# @copyright 2017 Sascha Peter
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
{%-   elif value is iterable -%}
{%-     for single_value in value %}
{{ key }} {{ single_value }}
{%-     endfor -%}
{%-   endif -%}
{%- endmacro -%}

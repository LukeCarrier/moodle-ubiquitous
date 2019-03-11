#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@.carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{%- macro postgresql_config_option(key, value) -%}
{%-   if value is string -%}
{{ key }} = {{ value | yaml_squote }}
{%-   elif value is sameas False or value is sameas True -%}
{{ key }} = {{ 'yes' if value else 'no' }}
{%-   elif value is iterable -%}
{{ key }} = {{ value | join(', ') }}
{%-   endif -%}
{%- endmacro -%}

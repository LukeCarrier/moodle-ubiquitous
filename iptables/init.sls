include:
  - base

{% for rule in salt['pillar.get']('iptables:extra_rules', []) %}
iptables.extra_rules.{{ loop.index }}:
  iptables.append:
{% for pair in rule %}
    - {{ pair.keys()[0] }}: {{ pair.values()[0] | yaml }}
{% endfor %}
    - save: True
    - require:
      - iptables: iptables.default.input.established
    - require_in:
      - iptables: iptables.default.input.drop
{% endfor %}

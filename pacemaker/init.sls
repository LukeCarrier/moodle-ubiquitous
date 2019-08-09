{% from 'pacemaker/map.jinja' import pacemaker with context %}

pacemaker.pkgs:
  pkg.latest:
    - pkgs: {{ pacemaker.packages | yaml }}

pacemaker.user:
  user.present:
    - name: {{ pacemaker.user.name }}
    - password: {{ pacemaker.user.password }}
    - gid: {{ pacemaker.user.gid }}
    - fullname: {{ pacemaker.user.fullname }}
    - home: {{ pacemaker.user.home }}
    - shell: {{ pacemaker.user.shell }}
    - require:
      - pkg: pacemaker.pkgs

# Once we've managed to authenticate nodes Pacemaker is able to synchronise this
# configuration across the cluster, so we only apply it to one of the nodes.
# Applying these operations across multiple hosts might result in data races.
{% if salt['grains.get']('pacemaker:configure') %}
pacemaker.cluster_setup:
  pcs.cluster_setup: {{ pacemaker.cluster_setup | yaml }}

  {% for prop, value in pacemaker.properties.items() %}
pacemaker.props.{{ prop }}:
  pcs.prop_has_value:
    - prop: {{ prop }}
    - value: {{ value }}
  {% endfor %}

  {% for name, res in pacemaker.resources.items() %}
pacemaker.res.{{ name }}:
  pcs.resource_present: {{ res | yaml }}
  {% endfor %}
{% endif %}

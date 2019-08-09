{% from 'nfs/map.jinja' import nfs with context %}

include:
  - nfs.common

nfs.client.pkgs:
  pkg.latest:
    - pkgs: {{ nfs.client_packages | yaml }}

{% for basename, mount in salt['pillar.get']('nfs:imports', {}).items() %}
nfs.client.dir.{{ basename }}:
  file.directory:
    - name: {{ mount.mountpoint }}
    - makedirs: True

nfs.client.mount.{{ basename }}:
  mount.mounted:
    - name: {{ mount.mountpoint }}
    - device: {{ mount.device }}
    - fstype: nfs
  {% if 'opts' in mount %}
    - opts: {{ mount.get('opts') }}
  {% endif %}
    - require:
      - file: nfs.client.dir.{{ basename }}
{% endfor %}

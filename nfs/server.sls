{% from 'nfs/map.jinja' import nfs with context %}

include:
  - nfs.common

nfs.server.pkgs:
  pkg.latest:
    - pkgs: {{ nfs.server_packages | yaml }}

# Managed by pacemaker
nfs.server.kernel-server.service:
  service.disabled:
    - name: nfs-kernel-server

nfs.server.default.kernel-server:
  file.managed:
    - name: /etc/default/nfs-kernel-server
    - source: salt://nfs/default/default.jinja
    - template: jinja
    - context:
      values: {{ nfs.kernel_server.default | yaml }}
    - user: root
    - group: root
    - mode: 0644

{% for name, value in nfs.sysctl.parameters.items() %}
nfs.server.sysctl.value.{{ name }}:
  sysctl.present:
    - name: {{ name }}
    - value: {{ value }}
    - config: /etc/sysctl.d/{{ nfs.sysctl.priority }}-ubiquitous-nfs.conf
  {% if pillar['systemd']['apply'] %}
    - onchanges_in:
      - cmd: nfs.server.sysctl.restart
  {% endif %}
{% endfor %}

{% if pillar['systemd']['apply'] %}
nfs.server.sysctl.restart:
  cmd.run:
    - name: |
        systemctl try-restart \
            nfs-config.service \
            nfs-server.service \
            rpc-statd.service \
            rpcbind.service
{% endif %}

nfs.server.exports:
  file.managed:
    - name: /etc/exports
    - onchanges_in:
      - cmd: nfs.server.exports.apply

nfs.server.exports.apply:
  cmd.run:
    - name: exportfs -ar

{% from 'nfs/map.jinja' import nfs with context %}

nfs.common.pkgs:
  pkg.latest:
    - pkgs: {{ nfs.common_packages | yaml }}

nfs.common.default.common:
  file.managed:
    - name: /etc/default/nfs-common
    - source: salt://nfs/default/default.jinja
    - template: jinja
    - context:
      values: {{ nfs.common.default | yaml }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nfs.common.pkgs

nfs.common.idmapd.conf:
  file.managed:
    - name: /etc/idmapd.conf
    - source: salt://nfs/ini/ini.jinja
    - template: jinja
    - context:
      values: {{ nfs.idmapd | yaml }}
    - user: root
    - group: root
    - mode: 0644

nfs.common.modprobe:
  file.managed:
    - name: /etc/modprobe.d/ubiquitous-nfs.conf
    - source: salt://nfs/modprobe/modprobe.conf.jinja
    - template: jinja
    - context:
      values: {{ nfs.modprobe | yaml }}
    - user: root
    - group: root
    - mode: 0644

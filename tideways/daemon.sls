{% from 'tideways/map.jinja' import tideways with context %}

include:
  - tideways.repo

tideways.daemon.pkgs:
  pkg.installed:
    - pkgs: {{ tideways.daemon.packages }}

tideways.daemon.defaults:
  file.managed:
    - name: /etc/default/tideways-daemon
    - source: salt://tideways/tideways/defaults.jinja
    - template: jinja
    - context:
      service: daemon
      flags: {{ tideways.daemon.flags }}
    - user: root
    - group: root
    - mode: 0644

tideways.daemon.config:
  file.directory:
    - name: /etc/tideways-daemon
    - user: tideways
    - group: tideways
    - mode: 0755

tideways.daemon.server_certificate:
  file.managed:
    - name: /etc/tideways-daemon/proxy.crt
    - contents_pillar: tideways:daemon:server_cert
    - user: tideways
    - group: tideways
    - mode: 0644

tideways.daemon.restart:
  cmd.run:
    - name: systemctl restart tideways-daemon
    - onchanges:
      - file: tideways.daemon.defaults

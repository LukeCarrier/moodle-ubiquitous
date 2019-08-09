{% from 'tcpwrappers/map.jinja' import tcpwrappers with context %}
{% from 'tcpwrappers/macros.jinja' import tcpwrappers_access_file %}

tcpwrappers.pkgs:
  pkg.latest:
    - name: libwrap0

{{ tcpwrappers_access_file('hosts.deny') }}
{{ tcpwrappers_access_file('hosts.allow') }}

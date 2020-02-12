{% from 'tideways/map.jinja' import tideways with context %}

include:
  - tideways.repo

tideways.proxy.pkgs:
  pkg.installed:
    - pkgs: {{ tideways.proxy.packages }}
    - require:
      - pkgrepo: tideways.repo

tideways.proxy.systemd.unit:
  file.managed:
    - name: /etc/systemd/system/tideways-proxy.service
    - source: salt://tideways/systemd/tideways-proxy.service
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: tideways.proxy.pkgs

tideways.proxy.systemd.template-unit:
  file.managed:
    - name: /etc/systemd/system/tideways-proxy@.service
    - source: salt://tideways/systemd/tideways-proxy@.service
    - user: root
    - group: root
    - mode: 0644
    - require:
      - file: tideways.proxy.systemd.unit
      - pkg: tideways.proxy.pkgs

{% for name in tideways.proxy.certificates.keys() %}
tideways.proxy.certificate.{{ name }}:
  file.managed:
    - name: /etc/tideways-proxy/{{ name }}.crt
    - contents_pillar: tideways:proxy:certificates:{{ name }}
    - user: tideways
    - group: tideways
    - mode: 0644
    - require:
      - pkg: tideways.proxy.pkgs
{% endfor %}

{% for name in tideways.proxy.private_keys.keys() %}
tideways.proxy.key.{{ name }}:
  file.managed:
    - name: /etc/tideways-proxy/{{ name }}.key
    - contents_pillar: tideways:proxy:private_keys:{{ name }}
    - user: tideways
    - group: tideways
    - mode: 0600
    - require:
      - pkg: tideways.proxy.pkgs
{% endfor %}

{% for name, config in tideways.proxy.instances.items() %}
tideways.proxy.defaults.{{ name }}:
  file.managed:
    - name: /etc/default/tideways-proxy.{{ name }}
    - source: salt://tideways/tideways/defaults.jinja
    - template: jinja
    - context:
      service: proxy
      flags: {{ config.flags }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: tideways.proxy.pkgs

tideways.proxy.enable.{{ name }}:
  service.enabled:
    - name: tideways-proxy@{{ name }}
    - require:
      - file: tideways.proxy.systemd.template-unit

tideways.proxy.restart.{{ name }}:
  cmd.run:
    - name: systemctl restart tideways-proxy@{{ name }}
    - onchanges:
      - file: tideways.proxy.defaults.{{ name }}
    - require:
      - file: tideways.proxy.systemd.template-unit
{% endfor %}



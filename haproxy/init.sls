#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

haproxy.pkgs:
  pkg.latest:
    - name: haproxy

haproxy.default:
  file.managed:
    - name: /etc/default/haproxy
    - source: salt://haproxy/default/haproxy.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

haproxy.config.errors:
  file.directory:
    - name: /etc/haproxy/errors
    - user: root
    - group: root
    - mode: 0755
    - require:
      - pkg: haproxy.pkgs

haproxy.config.config:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - contents_pillar: haproxy:config
    - user: root
    - group: root
    - mode: 0644

{% for error in salt['pillar.get']('haproxy:error_files', {}).keys() %}
haproxy.config.errors.{{ error }}:
  file.managed:
    - name: /etc/haproxy/errors/{{ error }}.http
    - source: salt://haproxy/haproxy/error.http.jinja
    - template: jinja
    - context:
      error: '{{ error }}'
    - user: root
    - group: root
    - mode: 0644
    - require:
      - file: haproxy.config.errors
{% endfor %}

{% for type in ['backend', 'frontend'] %}
haproxy.config.{{ type }}s:
  file.directory:
    - name: /etc/haproxy/{{ type }}s.d
    - user: root
    - group: root
    - mode: 0755
    - require:
      - pkg: haproxy.pkgs

  {% for item in salt['pillar.get']('haproxy:' + type + 's', {}).keys() %}
haproxy.config.{{ type }}s.{{ item }}:
  file.managed:
    - name: /etc/haproxy/{{ type }}s.d/{{ item }}.cfg
    - source: salt://haproxy/haproxy/fragment.cfg.jinja
    - template: jinja
    - context:
      type: {{ type }}
      item: {{ item }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - file: haproxy.config.{{ type }}s
    - onchanges_in:
      - cmd: haproxy.reload
  {% endfor %}
{% endfor %}

haproxy.service:
  service.running:
    - name: haproxy
    - enable: True
    - require:
      - pkg: haproxy.pkgs

haproxy.reload:
  cmd.run:
    - name: systemctl reload haproxy || systemctl restart haproxy
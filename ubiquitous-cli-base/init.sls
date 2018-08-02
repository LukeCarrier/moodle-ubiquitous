#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - ubiquitous-cli-base

ubiquitous-cli:
  file.directory:
    - name: /usr/local/ubiquitous
    - user: root
    - group: root
    - mode: 0755

{% for dir in ['bin', 'etc', 'lib', 'share'] %}
ubiquitous-cli.{{ dir }}:
  file.directory:
    - name: /usr/local/ubiquitous/{{ dir }}
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: ubiquitous-cli
{% endfor %}

ubiquitous-cd.local.lib.ubiquitous-core:
  file.managed:
    - name: /usr/local/ubiquitous/lib/ubiquitous-core
    - source: salt://ubiquitous-cli-base/local/lib/ubiquitous-core
    - user: root
    - group: root
    - mode: 0644
    - require:
      - file: ubiquitous-cli.lib

ubiquitous-cd.local.etc.ubiquitous-paths:
  file.managed:
    - name: /usr/local/ubiquitous/etc/ubiquitous-paths
    - source: salt://ubiquitous-cli-base/local/etc/ubiquitous-paths
    - user: root
    - group: root
    - mode: 0600
    - require:
      - file: ubiquitous-cli.etc

ubiquitous-cd.local.etc.ubiquitous-platforms:
  file.managed:
    - name: /usr/local/ubiquitous/etc/ubiquitous-platforms
    - source: salt://ubiquitous-cli-base/local/etc/ubiquitous-platforms.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - require:
      - file: ubiquitous-cli.etc

{% for script in ['install-release', 'set-current-release'] %}
ubiquitous-cd.local.bin.ubiquitous-{{ script }}:
  file.managed:
  - name: /usr/local/ubiquitous/bin/ubiquitous-{{ script }}
  - source: salt://ubiquitous-cli-base/local/bin/ubiquitous-{{ script }}
  - user: root
  - group: root
  - mode: 0755
  - require:
    - file: ubiquitous-cli.bin
{% endfor %}

{% for name, contents in salt['pillar.get']('ubiquitous-cd:scripts', {}).items() %}
/usr/local/ubiquitous/bin/{{ name }}:
  file.managed:
    - contents: {{ contents | yaml_encode }}
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: ubiquitous-cli.bin
{% endfor %}

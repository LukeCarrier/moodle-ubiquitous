#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

#
# Deployment tools and configuration
#

include:
  - app-ubiquitous-dirs

{% for script in ['info', 'install-release', 'set-current-release']: %}
/usr/local/ubiquitous/bin/ubiquitous-{{ script }}:
  file.managed:
    - source: salt://app-gocd-agent/local/bin/ubiquitous-{{ script }}
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: app-ubiquitous-dirs.bin
{% endfor %}

{% for name, contents in salt['pillar.get']('gocd-agent:scripts', {}).items() %}
/usr/local/ubiquitous/bin/{{ name }}:
  file.managed:
    - contents: {{ contents | yaml_encode }}
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: app-ubiquitous-dirs.bin
{% endfor %}

/usr/local/ubiquitous/lib/ubiquitous-lib:
  file.managed:
    - source: salt://app-gocd-agent/local/lib/ubiquitous-lib
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: app-ubiquitous-dirs.lib

/usr/local/ubiquitous/etc/ubiquitous-platforms:
  file.managed:
    - source: salt://app-gocd-agent/local/etc/ubiquitous-platforms.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - require:
      - file: app-ubiquitous-dirs.etc

#
# Sudo
#

/etc/sudoers.d/go-agent:
  file.managed:
    - source: salt://app-gocd-agent/sudo/go-agent
    - user: root
    - group: root
    - mode: 0440

#
# Filesystem permissions
#

{% if pillar['acl']['apply'] %}
{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
app-gocd-agent.{{ domain }}.home:
  acl.present:
    - name: {{ platform['user']['home'] }}
    - acl_type: user
    - acl_name: go
    - perms: rwx
    - recurse: True

app-gocd-agent.{{ domain }}.home.default:
  acl.present:
    - name: {{ platform['user']['home'] }}
    - acl_type: default:user
    - acl_name: go
    - perms: rwx
    - recurse: True
{% endfor %}
{% endif %}

#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

#
# Deployment tools and configuration
#

/usr/local/ubiquitous:
  file.directory:
    - user: root
    - group: root
    - mode: 0750

/usr/local/ubiquitous/bin:
  file.directory:
    - user: root
    - group: root
    - mode: 0750
    - require:
      - file: /usr/local/ubiquitous

/usr/local/ubiquitous/libexec:
  file.directory:
    - user: root
    - group: root
    - mode: 0750
    - require:
      - file: /usr/local/ubiquitous

/usr/local/ubiquitous/etc:
  file.directory:
    - user: root
    - group: root
    - mode: 0750
    - require:
      - file: /usr/local/ubiquitous

/usr/local/ubiquitous/bin/ubiquitous-permissions:
  file.managed:
    - source: salt://app-gocd-agent/bin/ubiquitous-permissions
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: /usr/local/ubiquitous/bin

/usr/local/ubiquitous/libexec/ubiquitous-lib:
  file.managed:
    - source: salt://app-gocd-agent/libexec/ubiquitous-lib
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: /usr/local/ubiquitous/libexec

/usr/local/ubiquitous/etc/ubiquitous-platforms:
  file.managed:
    - source: salt://app-gocd-agent/etc/ubiquitous-platforms.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - require:
      - file: /usr/local/ubiquitous/etc

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

{% for domain, platform in pillar['platforms'].items() %}
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

app-gocd-agent.{{ domain }}.htdocs:
  acl.present:
    - name: {{ platform['user']['home'] }}/htdocs
    - acl_type: user
    - acl_name: go
    - perms: rwx
    - recurse: True

app-gocd-agent.{{ domain }}.htdocs.default:
  acl.present:
    - name: {{ platform['user']['home'] }}/htdocs
    - acl_type: default:user
    - acl_name: go
    - perms: rwx
    - recurse: True
{% endfor %}

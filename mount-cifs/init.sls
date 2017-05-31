mount-cifs.pkgs:
  pkg.latest:
    - pkgs:
      - cifs-utils

mount-cifs.creds:
  file.directory:
  - name: /etc/fstab.cifs
  - user: root
  - group: root
  - mode: 0700

{% for basename, mount in pillar['system']['cifs_mounts'].items() %}
mount-cifs.{{ basename }}.dir:
  file.directory:
    - name: {{ mount['mountpoint'] }}
    - user: {{ mount['mountpoint_user'] }}
    - group: {{ mount['mountpoint_group'] }}
    - makedirs: True

mount-cifs.{{ basename }}.creds:
  file.managed:
    - name: /etc/fstab.cifs/{{ basename }}
    - source: salt://mount-cifs/cifs/credential.jinja
    - template: jinja
    - context:
      domain: {{ mount['domain'] | yaml_encode }}
      username: {{ mount['username'] | yaml_encode }}
      password: {{ mount['password'] | yaml_encode }}
    - user: root
    - group: root
    - mode: 0600

mount-cifs.{{ basename }}.mount:
  mount.mounted:
    - name: {{ mount['mountpoint'] | yaml_encode }}
    - device: {{ mount['device'] | yaml_encode }}
    - fstype: cifs
    - opts:
      - vers={{ mount['vers'] | yaml_encode }}
      - cache=strict
      - sec={{ mount['sec'] }}
      - credentials=/etc/fstab.cifs/{{ basename }}
      - uid={{ mount['uid'] }}
    - extra_mount_invisible_keys:
      - credentials
      - uid
    - require:
      - file: mount-cifs.{{ basename }}.dir
      - file: mount-cifs.{{ basename }}.creds
{% endfor %}

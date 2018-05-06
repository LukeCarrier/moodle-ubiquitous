#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

ubiquitous-dirs:
  file.directory:
    - name: /usr/local/ubiquitous
    - user: root
    - group: root
    - mode: 0755

ubiquitous-dirs.bin:
  file.directory:
    - name: /usr/local/ubiquitous/bin
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: ubiquitous-dirs

ubiquitous-dirs.lib:
  file.directory:
    - name: /usr/local/ubiquitous/lib
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: ubiquitous-dirs

ubiquitous-dirs.etc:
  file.directory:
    - name: /usr/local/ubiquitous/etc
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: ubiquitous-dirs

ubiquitous-dirs.share:
  file.directory:
    - name: /usr/local/ubiquitous/share
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: ubiquitous-dirs

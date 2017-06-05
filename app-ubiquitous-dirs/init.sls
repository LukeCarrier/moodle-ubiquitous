app-ubiquitous-dirs:
  file.directory:
    - name: /usr/local/ubiquitous
    - user: root
    - group: root
    - mode: 0755

app-ubiquitous-dirs.bin:
  file.directory:
    - name: /usr/local/ubiquitous/bin
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: app-ubiquitous-dirs

app-ubiquitous-dirs.lib:
  file.directory:
    - name: /usr/local/ubiquitous/lib
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: app-ubiquitous-dirs

app-ubiquitous-dirs.etc:
  file.directory:
    - name: /usr/local/ubiquitous/etc
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: app-ubiquitous-dirs

app-ubiquitous-dirs.share:
  file.directory:
    - name: /usr/local/ubiquitous/share
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: app-ubiquitous-dirs

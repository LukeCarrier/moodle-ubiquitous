#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

{% set user = salt['pillar.get']('moodle-componentmgr:user', 'root') %}
{% set group = salt['pillar.get']('moodle-componentmgr:group', 'root') %}
{% set home_dir = salt['pillar.get']('moodle-componentmgr:home_dir', '/root') %}

moodle-componentmgr.pkgs:
  pkg.latest:
    - pkgs:
      - php7.0-cli
      - php7.0-curl
      - php7.0-xml
      - php7.0-zip
      - composer
      - git

moodle-componentmgr.composer:
  file.directory:
    - name: {{ home_dir}}/.composer
    - user: {{ user }}
    - group: {{ group }}
    - mode: 0700

moodle-componentmgr.composer.composer.json:
  file.managed:
    - name: {{ home_dir }}/.composer/composer.json
    - source: salt://moodle-componentmgr/composer/composer.json
    - user: {{ user }}
    - group: {{ group }}
    - mode: 0600
    - require:
      - file: moodle-componentmgr.composer

moodle-componentmgr.composer.path:
  file.blockreplace:
    - name: {{ home_dir }}/.profile
    - content: PATH="$HOME/.composer/vendor/bin:$PATH"
    - marker_start: '# start:moodle-componentmgr'
    - marker_end: '# end:moodle-componentmgr'
    - append_if_not_found: True

moodle-componentmgr.composer.install:
  composer.installed:
    - name: {{ home_dir }}/.composer
    - user: {{ user }}
    - no_dev: True
    - require:
      - pkg: moodle-componentmgr.pkgs
      - file: moodle-componentmgr.composer.composer.json

{% from 'tideways/map.jinja' import tideways with context %}

tideways.repo:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/tideways.list
    - humanname: Tideways
    - name: {{ tideways.repo.source }}
    - keyserver: {{ tideways.repo.key.server }}
    - keyid: {{ tideways.repo.key.id }}

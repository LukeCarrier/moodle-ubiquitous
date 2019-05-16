#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

include:
  - ubiquitous-cli-base

web-error-pages.ubiquitous-error-pages:
  file.directory:
    - name: /usr/local/ubiquitous/share/ubiquitous-error-pages
    - user: root
    - group: root
    - mode: 0755
    - require:
      - ubiquitous-cli.share

web-error-pages.share.ubiquitous-error-pages.logos:
  file.directory:
    - name: /usr/local/ubiquitous/share/ubiquitous-error-pages/logos
    - user: root
    - group: root
    - mode: 0755
    - require:
      - web-error-pages.ubiquitous-error-pages

web-error-pages.snippet:
  file.managed:
    - name: /etc/nginx/snippets/error-pages.conf
    - source: salt://web-error-pages/nginx/error-pages.conf.jinja
    - template: jinja
    - context:
      error_pages: {{ salt['pillar.get']('web-error-pages:error-pages') | yaml }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx.pkgs

{% for lang, pages in salt['pillar.get']('web-error-pages:translated', {}).items() %}
web-error-pages.page.lang.{{ lang }}:
  file.directory:
    - name: /usr/local/ubiquitous/share/ubiquitous-error-pages/{{ lang }}
    - user: root
    - group: root
    - mode: 0755
    - require:
      - web-error-pages.ubiquitous-error-pages

{% for status, body in pages['pages'].items() %}
# Note the context value's syntax here. PyYAML will incorrectly parse the
# structure if contents is a multi-line string. :(
web-error-pages.page.{{ lang }}.{{ status }}:
  file.managed:
    - name: /usr/local/ubiquitous/share/ubiquitous-error-pages/{{ lang }}/{{ status }}.html
    - contents: {{ pages['layout'] | yaml_encode }}
    - template: jinja
    - context: { body: {{ body | yaml_encode }} }
    - require:
      - web-error-pages.page.lang.{{ lang }}
{% endfor %}
{% endfor %}

{% for domain, platform in salt['pillar.get']('platforms', {}).items() %}
web-error-pages.{{ platform['basename'] }}.logo.base64:
  file.managed:
    - name: /usr/local/ubiquitous/share/ubiquitous-error-pages/logos/{{ platform['basename'] }}.png.base64
    - contents_pillar: platforms:{{ domain }}:logo
    - user: root
    - group: root
    - mode: 0600
    - require:
      - web-error-pages.share.ubiquitous-error-pages.logos

web-error-pages.{{ platform['basename'] }}.logo:
  cmd.wait:
    - name: |
        base64 --decode /usr/local/ubiquitous/share/ubiquitous-error-pages/logos/{{ platform['basename'] }}.png.base64 -d \
                >/usr/local/ubiquitous/share/ubiquitous-error-pages/logos/{{ platform['basename'] }}.png
        rm -f /usr/local/ubiquitous/share/ubiquitous-error-pages/logos/{{ platform['basename'] }}.png.base64
    - watch:
      - web-error-pages.{{ platform['basename'] }}.logo.base64
  file.managed:
    - name: /usr/local/ubiquitous/share/ubiquitous-error-pages/logos/{{ platform['basename'] }}.png
    - replace: False
    - user: root
    - group: root
    - mode: 0644

web-error-pages.{{ platform['basename'] }}.nginx:
  file.managed:
    - name: /etc/nginx/sites-extra/{{ platform['basename'] }}.error-pages.conf
    - source: salt://web-error-pages/nginx/platform.error-pages.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
    - user: root
    - group: root
    - mode: 0644
    - onchanges_in:
      - web-error-pages.nginx.reload
{% endfor %}

{% if pillar['systemd']['apply'] %}
web-error-pages.nginx.reload:
  cmd.run:
    - name: systemctl reload nginx || systemctl restart nginx
    - onchanges:
      - web-error-pages.snippet
{% endif %}

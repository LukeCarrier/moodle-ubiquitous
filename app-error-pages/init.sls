#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

include:
  - app-ubiquitous-dirs

app-error-pages.ubiquitous-error-pages:
  file.directory:
    - name: /usr/local/ubiquitous/share/ubiquitous-error-pages
    - user: root
    - group: root
    - mode: 0755
    - require:
      - app-ubiquitous-dirs.share

app-error-pages.share.ubiquitous-error-pages.logos:
  file.directory:
    - name: /usr/local/ubiquitous/share/ubiquitous-error-pages/logos
    - user: root
    - group: root
    - mode: 0755
    - require:
      - app-error-pages.ubiquitous-error-pages

app-error-pages.snippet:
  file.managed:
    - name: /etc/nginx/snippets/error-pages.conf
    - source: salt://app-error-pages/nginx/error-pages.conf.jinja
    - template: jinja
    - context:
      error_pages: {{ salt['pillar.get']('app-error-pages:error-pages') | yaml }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - nginx

{% for lang, pages in salt['pillar.get']('app-error-pages:translated').items() %}
app-error-pages.page.lang.{{ lang }}:
  file.directory:
    - name: /usr/local/ubiquitous/share/ubiquitous-error-pages/{{ lang }}
    - user: root
    - group: root
    - mode: 0755
    - require:
      - app-error-pages.ubiquitous-error-pages

{% for status, body in pages['pages'].items() %}
# Note the context value's syntax here. PyYAML will incorrectly parse the
# structure if contents is a multi-line string. :(
app-error-pages.page.{{ lang }}.{{ status }}:
  file.managed:
    - name: /usr/local/ubiquitous/share/ubiquitous-error-pages/{{ lang }}/{{ status }}.html
    - contents: {{ pages['layout'] | yaml_encode }}
    - template: jinja
    - context: { body: {{ body | yaml_encode }} }
    - require:
      - app-error-pages.page.lang.{{ lang }}
{% endfor %}
{% endfor %}

{% for domain, platform in salt['pillar.get']('platforms:moodle_platforms', {}).items() %}
app-error-pages.{{ platform['basename'] }}.logo.base64:
  file.managed:
    - name: /usr/local/ubiquitous/share/ubiquitous-error-pages/logos/{{ platform['basename'] }}.png.base64
    - contents_pillar: platforms:{{ domain }}:logo
    - user: root
    - group: root
    - mode: 0600
    - require:
      - app-error-pages.share.ubiquitous-error-pages.logos

app-error-pages.{{ platform['basename'] }}.logo:
  cmd.wait:
    - name: |
        base64 --decode /usr/local/ubiquitous/share/ubiquitous-error-pages/logos/{{ platform['basename'] }}.png.base64 -d \
                >/usr/local/ubiquitous/share/ubiquitous-error-pages/logos/{{ platform['basename'] }}.png
        rm -f /usr/local/ubiquitous/share/ubiquitous-error-pages/logos/{{ platform['basename'] }}.png.base64
    - watch:
      - app-error-pages.{{ platform['basename'] }}.logo.base64
  file.managed:
    - name: /usr/local/ubiquitous/share/ubiquitous-error-pages/logos/{{ platform['basename'] }}.png
    - replace: False
    - user: root
    - group: root
    - mode: 0644

app-error-pages.{{ platform['basename'] }}.nginx:
  file.managed:
    - name: /etc/nginx/sites-extra/{{ platform['basename'] }}.error-pages.conf
    - source: salt://app-error-pages/nginx/platform.error-pages.conf.jinja
    - template: jinja
    - context:
      domain: {{ domain }}
    - user: root
    - group: root
    - mode: 0644
    - onchanges_in:
      - app-error-pages.nginx.reload
{% endfor %}

{% if pillar['systemd']['apply'] %}
app-error-pages.nginx.reload:
  cmd.run:
    - name: systemctl reload nginx || systemctl restart nginx
    - onchanges:
      - app-error-pages.snippet
{% endif %}

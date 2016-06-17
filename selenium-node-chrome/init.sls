#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke.carrier@floream.com>
# @copyright 2015 Floream Limited
#

/etc/yum.repos.d/google-chrome.repo:
  file.managed:
    - source: salt://selenium-node-chrome/repos/google-chrome.repo
    - user: root
    - group: root
    - mode: 0644

google-chrome-stable:
  pkg.installed:
    - require:
      - file: /etc/yum.repos.d/google-chrome.repo

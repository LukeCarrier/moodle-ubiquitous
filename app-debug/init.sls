#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke.carrier@floream.com>
# @copyright 2015 Floream Limited
#

#
# Xdebug
#

php56w-pecl-xdebug:
  pkg.installed: []

/etc/php.d/xdebug.ini:
  file.managed:
    - source: salt://app-debug/php/xdebug.ini
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: php56w-pecl-xdebug

/etc/php-fpm.d/moodle.debug.conf:
  file.managed:
    - source: salt://app-debug/php/moodle.debug.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

#
# MailCatcher SMTP port
#

'semanage port -a -t smtp_port_t -p tcp 1025':
  cmd.run: []

#
# SELinux troubleshooting
#

setroubleshoot-server:
  pkg.installed: []

#
# Vim
#

vim-enhanced:
  pkg.installed: []

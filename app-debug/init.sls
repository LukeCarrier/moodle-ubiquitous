#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

#
# Xdebug
#

php.xdebug:
  pkg.installed:
    - pkgs:
      - php70w-pecl-xdebug

/etc/php.d/xdebug.ini:
  file.managed:
    - source: salt://app-debug/php/xdebug.ini
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: php.xdebug

/etc/php-fpm.d/moodle.debug.conf:
  file.managed:
    - source: salt://app-debug/php/moodle.debug.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

#
# nginx
#

/home/moodle/data:
  # acl.present:
  #   - acl_type: user
  #   - acl_name: nginx
  #   - perms: rx
  #   - require:
  #     - file: /home/moodle/data
  cmd.run:
    - name: 'setfacl -m user:nginx:rx /home/moodle/data'
    - require:
      - file: /home/moodle/data

/home/moodle/data/behat-faildump:
  # acl.present:
  #   - acl_type: user
  #   - acl_name: nginx
  #   - perms: rx
  #   - require:
  #     - file: /home/moodle/data/behat-faildump
  cmd.run:
    - name: 'setfacl -m user:nginx:rx /home/moodle/data/behat-faildump'
    - require:
      - file: /home/moodle/data/behat-faildump

/etc/nginx/conf.d/moodle.debug.conf:
  file.managed:
    - source: salt://app/nginx/moodle.debug.conf
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: nginx

#
# MailCatcher SMTP port
#

'semanage port -a -t smtp_port_t -p tcp 1025 || true':
  cmd.run

#
# SELinux troubleshooting
#

setroubleshoot-server:
  pkg.installed

#
# Vim
#

vim-enhanced:
  pkg.installed

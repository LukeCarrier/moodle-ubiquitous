#
# Ubiquitous Redis
#
# @author Sascha Peter <sascha.o.peter@gmail.com>
# @copyright 2017 Sascha Peter
#

include:
  - base

#
# OS software requirements
#

os.packages:
  pkg.installed:
  - pkgs:
    - redis-sentinel

sentinel.config.values.set:
  file.managed:
    - name: /etc/sentinel/sentinel.conf
    - source: salt://sentinel/config/sentinel.conf.jinja
    - template: jinja
    # - watch_in:
    #   - service: redis.service.reload

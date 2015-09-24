#
# The Perfect Cluster: Moodle
#
# @author Luke Carrier <luke.carrier@floream.com>
# @copyright 2015 Floream Limited
#

base:
  '*':
    - base
  'app-*.*':
    - app
  'salt.*':
    - salt

admin:
  name: ubuntu
  password: gibberish
  groups: # Primary group is always named after user name
    - sudo
  home: /home/ubuntu

iptables:
  apply: False

locales:
  present:
    - en_AU.UTF-8
    - en_GB.UTF-8
    - en_US.UTF-8
  default: en_GB.UTF-8

systemd:
  apply: False

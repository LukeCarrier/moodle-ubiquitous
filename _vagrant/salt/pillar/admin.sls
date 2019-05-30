users:
  vagrant:
    fullname: Administrative user
    password: gibberish
    groups: # Primary group is always named after user name
      - sudo
    home: /home/vagrant

repositories:
  -
    - humanname: Ubiquitous
    - file: /etc/apt/sources.list.d/avado-sre-ubuntu-moodle-ubiquitous-{{ grains.oscodename }}.list
    - name: |
        deb http://ppa.launchpad.net/avado-sre/moodle-ubiquitous/ubuntu {{ grains.oscodename }} main
        # deb-src http://ppa.launchpad.net/avado-sre/moodle-ubiquitous/ubuntu {{ grains.oscodename }} main
    - keyserver: keyserver.ubuntu.com
    - keyid: 730D31D3C2E1968B

packages:
  - git
  - htop
  - tree
  - vim

acl:
  apply: True

locales:
  present:
    - en_AU.UTF-8 UTF-8
    - en_GB.UTF-8 UTF-8
    - en_US.UTF-8 UTF-8
  default: en_GB.UTF-8

sshd:
  Protocol:
    - 2
  UsePrivilegeSeparation: sandbox
  HostKey:
    - /etc/ssh/ssh_host_ed25519_key
    - /etc/ssh/ssh_host_rsa_key
    - /etc/ssh/ssh_host_ecdsa_key
    - /etc/ssh/ssh_host_dsa_key
  AuthenticationMethods: publickey
  PermitRootLogin: False
  PrintMotd: False
  PrintLastLog: True
  TCPKeepAlive: True
  AcceptEnv:
    - LANG
    - LC_*
  Subsystem:
    sftp: /usr/lib/openssh/sftp-server -f AUTHPRIV -l INFO
  UsePAM: True

systemd:
  apply: True

sudoers:
  passwordless:
    - '%sudo ALL=(ALL:ALL) NOPASSWD: ALL'

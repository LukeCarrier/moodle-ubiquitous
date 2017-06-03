users:
  ubuntu:
    fullname: Administrative user
    password: gibberish
    groups: # Primary group is always named after user name
      - sudo
    home: /home/ubuntu

acl:
  apply: False

locales:
  present:
    - en_AU.UTF-8 UTF-8
    - en_GB.UTF-8 UTF-8
    - en_US.UTF-8 UTF-8
  default: en_GB.UTF-8 UTF-8

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
  apply: False

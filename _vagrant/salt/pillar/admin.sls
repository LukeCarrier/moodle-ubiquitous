admin:
  packages:
    packages:
      - git
      - htop
      - tree
      - vim
  users:
    home_directories:
      - /home
    users:
      vagrant:
        fullname: Administrative user
        password: gibberish
        groups: # Primary group is always named after user name
          - sudo
        home: /home/vagrant
  sudoers:
    passwordless:
      - '%sudo ALL=(ALL:ALL) NOPASSWD: ALL'

acl:
  apply: True

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

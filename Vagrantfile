Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"

  config.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh", disabled: true
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/home/vagrant/sync", disabled: true

  # Workaround for https://github.com/mitchellh/vagrant/issues/7613
  config.ssh.shell = 'bash --login --noprofile'

  config.vm.define "salt", primary: true do |salt|
    salt.vm.network "private_network", ip: "192.168.120.5",
                    netmask: "255.255.255.0"
    salt.vm.hostname = "salt.moodle"

    salt.ssh.port = 2223
    salt.vm.network "forwarded_port", guest: 22, host: salt.ssh.port

    # Fix host-only network adapters post Guest Additions installation
    salt.vm.provision "salt-network", type: "shell", inline: "systemctl restart network"

    salt.vm.synced_folder ".", "/srv/salt", type: "rsync"
    salt.vm.provision "salt-salt", type: "shell", path: "vagrant/salt/install",
                      args: [ "--master", "app-debug-1,db-1,mail-debug,salt,selenium-hub,selenium-node-chrome,selenium-node-firefox", "--minion", "salt", "--root", "/srv/salt/vagrant/salt" ]
  end

  config.vm.define "app-debug-1" do |appdebug1|
    appdebug1.vm.network "private_network", ip: "192.168.120.50",
                         netmask: "255.255.255.0"
    appdebug1.vm.hostname = "app-debug-1.moodle"

    appdebug1.ssh.port = 2224
    appdebug1.vm.network "forwarded_port", guest: 22, host: appdebug1.ssh.port

    appdebug1.vm.network "forwarded_port", guest: 80, host: 2280

    # Fix host-only network adapters post Guest Additions installation
    appdebug1.vm.provision "salt-network", type: "shell", inline: "systemctl restart network"

    appdebug1.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    appdebug1.vm.provision "app-debug-1-salt", type: "shell", path: "vagrant/salt/install", args: [ "--minion", "app-debug-1", "--root", "/vagrant/salt" ]

    appdebug1.vm.synced_folder "../moodle", "/home/moodle/htdocs", type: "rsync", owner: 'moodle', group: 'moodle',
                          rsync__exclude: [".git/", "phpunit.xml"],
                          rsync__args: ["--rsync-path='sudo rsync'", "--archive", "--compress", "--delete"]
  end

  config.vm.define "db-1" do |db1|
    db1.vm.network "private_network", ip: "192.168.120.150",
                   netmask: "255.255.255.0"
    db1.vm.hostname = "db-1.moodle"

    db1.ssh.port = 2225
    db1.vm.network "forwarded_port", guest: 22, host: db1.ssh.port

    # Fix host-only network adapters post Guest Additions installation
    db1.vm.provision "salt-network", type: "shell", inline: "systemctl restart network"

    db1.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    db1.vm.provision "db-1-salt", type: "shell", path: "vagrant/salt/install", args: [ "--minion", "db-1", "--root", "/vagrant/salt" ]
  end

  config.vm.define "mail-debug" do |maildebug|
    maildebug.vm.network "private_network", ip: "192.168.120.200"
    maildebug.vm.hostname = "mail-debug.moodle"

    maildebug.ssh.port = 2226
    maildebug.vm.network "forwarded_port", guest: 22, host: maildebug.ssh.port

    maildebug.vm.network "forwarded_port", guest: 1025, host: 2325
    maildebug.vm.network "forwarded_port", guest: 1080, host: 2380

    # Fix host-only network adapters post Guest Additions installation
    maildebug.vm.provision "salt-network", type: "shell", inline: "systemctl restart network"

    maildebug.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    maildebug.vm.provision "mail-debug-salt", type: "shell", path: "vagrant/salt/install", args: [ "--minion", "mail-debug", "--root", "/vagrant/salt" ]
  end

  config.vm.define "selenium-hub" do |seleniumhub|
    seleniumhub.vm.network "private_network", ip: "192.168.120.100",
                           netmask: "255.255.255.0"
    seleniumhub.vm.hostname = "selenium-hub.moodle"

    seleniumhub.ssh.port = 2227
    seleniumhub.vm.network "forwarded_port", guest: 22, host: seleniumhub.ssh.port

    # Fix host-only network adapters post Guest Additions installation
    seleniumhub.vm.provision "salt-network", type: "shell", inline: "systemctl restart network"

    seleniumhub.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    seleniumhub.vm.provision "selenium-hub-salt", type: "shell", path: "vagrant/salt/install", args: ["--minion", "selenium-hub", "--root", "/vagrant/salt" ]
  end

  config.vm.define "selenium-node-chrome" do |seleniumnodechrome|
    seleniumnodechrome.vm.network "private_network", ip: "192.168.120.105",
                                  netmask: "255.255.255.0"
    seleniumnodechrome.vm.hostname = "selenium-node-chrome.moodle"

    seleniumnodechrome.ssh.port = 2228
    seleniumnodechrome.vm.network "forwarded_port", guest: 22, host: seleniumnodechrome.ssh.port

    # Fix host-only network adapters post Guest Additions installation
    seleniumnodechrome.vm.provision "salt-network", type: "shell", inline: "systemctl restart network"

    seleniumnodechrome.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    seleniumnodechrome.vm.provision "selenium-node-chrome-salt", type: "shell", path: "vagrant/salt/install", args: ["--minion", "selenium-node-chrome", "--root", "/vagrant/salt" ]

    seleniumnodechrome.vm.synced_folder "../moodle", "/var/lib/selenium/moodle", type: "rsync", owner: 'selenium', group: 'selenium',
                                        rsync__exclude: ".git/",
                                        rsync__args: ["--rsync-path='sudo rsync'", "--archive", "--compress", "--delete"]
  end

  config.vm.define "selenium-node-firefox" do |seleniumnodefirefox|
    seleniumnodefirefox.vm.network "private_network", ip: "192.168.120.110",
                                   netmask: "255.255.255.0"
    seleniumnodefirefox.vm.hostname = "selenium-node-firefox.moodle"

    seleniumnodefirefox.ssh.port = 2229
    seleniumnodefirefox.vm.network "forwarded_port", guest: 22, host: seleniumnodefirefox.ssh.port

    # Fix host-only network adapters post Guest Additions installation
    seleniumnodefirefox.vm.provision "salt-network", type: "shell", inline: "systemctl restart network"

    seleniumnodefirefox.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    seleniumnodefirefox.vm.provision "selenium-node-firefox-salt", type: "shell", path: "vagrant/salt/install", args: ["--minion", "selenium-node-firefox", "--root", "/vagrant/salt" ]

    seleniumnodefirefox.vm.synced_folder "../moodle", "/var/lib/selenium/moodle", type: "rsync", owner: 'selenium', group: 'selenium',
                                         rsync__exclude: ".git/",
                                         rsync__args: ["--rsync-path='sudo rsync'", "--archive", "--compress", "--delete"]
  end

  # If such a file exists, load the user's local configuration.
  #
  # This allows developers to extend the Vagrantfile without having to duplicate
  # the entire file.
  if File.exist? "Vagrantfile.local"
    instance_eval File.read("Vagrantfile.local"), "Vagrantfile.local"
  end
end

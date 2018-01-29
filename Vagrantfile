Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_version = ">= 20180126.0.0"

  config.vm.provider "virtualbox" do |v|
    v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  config.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh", disabled: true
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "salt", primary: true do |salt|
    salt.vm.network "private_network", ip: "192.168.120.5",
                    netmask: "255.255.255.0"
    salt.vm.hostname = "salt.moodle"

    salt.ssh.port = 2223
    salt.vm.network "forwarded_port", guest: 22, host: salt.ssh.port

    salt.vm.synced_folder ".", "/srv/salt", type: "rsync"
    salt.vm.synced_folder "./_vagrant/salt/pillar", "/srv/pillar", type: "rsync"
    salt.vm.provision "salt-salt", type: "shell", path: "./_vagrant/salt/install",
                      args: [ "--master", "app-debug-1,identity-proxy,identity-provider,db-pgsql-1,gocd,named,mail-debug,salt,selenium-hub,selenium-node-chrome,selenium-node-firefox", "--minion", "salt", "--root", "/srv/salt/_vagrant/salt" ]
  end

  config.vm.define "gocd" do |gocd|
    gocd.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end

    gocd.vm.network "private_network", ip: "192.168.120.10",
                    netmask: "255.255.255.0"
    gocd.vm.hostname = "gocd.moodle"

    gocd.ssh.port = 2230
    gocd.vm.network "forwarded_port", guest: 22, host: gocd.ssh.port

    gocd.vm.synced_folder "./_vagrant", "/vagrant", type: "rsync"
    gocd.vm.provision "gocd-salt", type: "shell", path: "./_vagrant/salt/install", args: [ "--minion", "gocd", "--root", "/vagrant/salt" ]
  end

  config.vm.define "named" do |named|
    named.vm.network "private_network", ip: "192.168.120.15",
                     netmask: "255.255.255.0"
    named.vm.hostname = "named.moodle"

    named.ssh.port = 2231
    named.vm.network "forwarded_port", guest: 22, host: named.ssh.port

    named.vm.synced_folder "./_vagrant", "/vagrant", type: "rsync"
    named.vm.provision "named-salt", type: "shell", path: "./_vagrant/salt/install", args: [ "--minion", "named", "--root", "/vagrant/salt" ]
  end

  config.vm.define "mail-debug" do |maildebug|
    maildebug.vm.network "private_network", ip: "192.168.120.200"
    maildebug.vm.hostname = "mail-debug.moodle"

    maildebug.ssh.port = 2226
    maildebug.vm.network "forwarded_port", guest: 22, host: maildebug.ssh.port

    maildebug.vm.synced_folder "./_vagrant", "/vagrant", type: "rsync"
    maildebug.vm.provision "mail-debug-salt", type: "shell", path: "./_vagrant/salt/install", args: [ "--minion", "mail-debug", "--root", "/vagrant/salt" ]
  end

  config.vm.define "selenium-hub" do |seleniumhub|
    seleniumhub.vm.network "private_network", ip: "192.168.120.100",
                           netmask: "255.255.255.0"
    seleniumhub.vm.hostname = "selenium-hub.moodle"

    seleniumhub.ssh.port = 2227
    seleniumhub.vm.network "forwarded_port", guest: 22, host: seleniumhub.ssh.port

    seleniumhub.vm.synced_folder "./_vagrant", "/vagrant", type: "rsync"
    seleniumhub.vm.provision "selenium-hub-salt", type: "shell", path: "./_vagrant/salt/install", args: ["--minion", "selenium-hub", "--root", "/vagrant/salt" ]
  end

  config.vm.define "selenium-node-chrome" do |seleniumnodechrome|
    seleniumnodechrome.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end

    seleniumnodechrome.vm.network "private_network", ip: "192.168.120.105",
                                  netmask: "255.255.255.0"
    seleniumnodechrome.vm.hostname = "selenium-node-chrome.moodle"

    seleniumnodechrome.ssh.port = 2228
    seleniumnodechrome.vm.network "forwarded_port", guest: 22, host: seleniumnodechrome.ssh.port

    seleniumnodechrome.vm.synced_folder "./_vagrant", "/vagrant", type: "rsync"
    seleniumnodechrome.vm.provision "selenium-node-chrome-salt", type: "shell", path: "./_vagrant/salt/install", args: ["--minion", "selenium-node-chrome", "--root", "/vagrant/salt" ]

    seleniumnodechrome.vm.synced_folder "../Moodle", "/home/vagrant/moodle", type: "rsync",
                                        owner: "vagrant", group: "vagrant",
                                        rsync__exclude: ".git/",
                                        rsync__args: ["--rsync-path='sudo rsync'", "--archive", "--compress", "--delete"]
  end

  config.vm.define "selenium-node-firefox" do |seleniumnodefirefox|
    seleniumnodefirefox.vm.network "private_network", ip: "192.168.120.110",
                                   netmask: "255.255.255.0"
    seleniumnodefirefox.vm.hostname = "selenium-node-firefox.moodle"

    seleniumnodefirefox.ssh.port = 2229
    seleniumnodefirefox.vm.network "forwarded_port", guest: 22, host: seleniumnodefirefox.ssh.port

    seleniumnodefirefox.vm.synced_folder "./_vagrant", "/vagrant", type: "rsync"
    seleniumnodefirefox.vm.provision "selenium-node-firefox-salt", type: "shell", path: "./_vagrant/salt/install", args: ["--minion", "selenium-node-firefox", "--root", "/vagrant/salt" ]

    seleniumnodefirefox.vm.synced_folder "../Moodle", "/home/vagrant/moodle", type: "rsync",
                                        owner: "vagrant", group: "vagrant",
                                        rsync__exclude: ".git/",
                                        rsync__args: ["--rsync-path='sudo rsync'", "--archive", "--compress", "--delete"]
  end

  config.vm.define "app-debug-1" do |appdebug1|
    appdebug1.vm.network "private_network", ip: "192.168.120.50",
                         netmask: "255.255.255.0"
    appdebug1.vm.hostname = "app-debug-1.moodle"

    appdebug1.ssh.port = 2224
    appdebug1.vm.network "forwarded_port", guest: 22, host: appdebug1.ssh.port

    appdebug1.vm.synced_folder "./_vagrant", "/vagrant", type: "rsync"
    appdebug1.vm.provision "app-debug-1-salt", type: "shell", path: "./_vagrant/salt/install", args: [ "--minion", "app-debug-1", "--root", "/vagrant/salt" ]

    appdebug1.vm.synced_folder "../Moodle", "/home/vagrant/releases/vagrant", type: "rsync",
                               owner: "vagrant", group: "vagrant",
                               rsync__exclude: [".git", "phpunit.xml", "behatrun*"],
                               rsync__rsync_path: "sudo rsync",
                               rsync__args: ["--archive", "--compress", "--delete"]
  end

  config.vm.define "db-pgsql-1" do |db1|
    db1.vm.network "private_network", ip: "192.168.120.150",
                   netmask: "255.255.255.0"
    db1.vm.hostname = "db-pgsql-1.moodle"

    db1.ssh.port = 2225
    db1.vm.network "forwarded_port", guest: 22, host: db1.ssh.port

    db1.vm.synced_folder "./_vagrant", "/vagrant", type: "rsync"
    db1.vm.provision "db-pgsql-1-salt", type: "shell", path: "./_vagrant/salt/install", args: [ "--minion", "db-pgsql-1", "--root", "/vagrant/salt" ]
  end

  config.vm.define "identity-provider" do |identityprovider|
    identityprovider.vm.network "private_network", ip: "192.168.120.55",
                         netmask: "255.255.255.0"
    identityprovider.vm.hostname = "identity-provider.moodle"

    identityprovider.ssh.port = 2232
    identityprovider.vm.network "forwarded_port", guest: 22, host: identityprovider.ssh.port

    identityprovider.vm.synced_folder "./_vagrant", "/vagrant", type: "rsync"
    identityprovider.vm.provision "identity-provider-salt", type: "shell", path: "./_vagrant/salt/install", args: [ "--minion", "identity-provider", "--root", "/vagrant/salt" ]

    identityprovider.vm.synced_folder "../SimpleSAMLphp-provider", "/home/vagrant/releases/vagrant", type: "rsync",
                                      owner: "vagrant", group: "vagrant",
                                      rsync__exclude: [".git", "phpunit.xml"],
                                      rsync__rsync_path: "sudo rsync",
                                      rsync__args: ["--archive", "--compress", "--delete"]
  end

  config.vm.define "identity-proxy" do |identityproxy|
    identityproxy.vm.network "private_network", ip: "192.168.120.60",
                         netmask: "255.255.255.0"
    identityproxy.vm.hostname = "identity-proxy.moodle"

    identityproxy.ssh.port = 2233
    identityproxy.vm.network "forwarded_port", guest: 22, host: identityproxy.ssh.port

    identityproxy.vm.synced_folder "./_vagrant", "/vagrant", type: "rsync"
    identityproxy.vm.provision "identity-proxy-salt", type: "shell", path: "./_vagrant/salt/install", args: [ "--minion", "identity-proxy", "--root", "/vagrant/salt" ]

    identityproxy.vm.synced_folder "../SimpleSAMLphp-proxy", "/home/vagrant/releases/vagrant", type: "rsync",
                                   owner: "vagrant", group: "vagrant",
                                   rsync__exclude: [".git", "phpunit.xml"],
                                   rsync__rsync_path: "sudo rsync",
                                   rsync__args: ["--archive", "--compress", "--delete"]
  end

  if Vagrant.has_plugin? "vagrant-group"
    config.group.groups = {
      "infrastructure" => [
        "salt",
        "mail-debug",
      ],
      "selenium" => [
        "selenium-hub",
        "selenium-node-chrome",
        "selenium-node-firefox",
      ],
      "moodle" => [
        "app-debug-1",
        "db-pgsql-1",
      ],
      "saml" => [
        "identity-provider",
        "identity-proxy",
      ],
    }
  end

  # If such a file exists, load the user's local configuration.
  #
  # This allows developers to extend the Vagrantfile without having to duplicate
  # the entire file.
  if File.exist? "Vagrantfile.local"
    instance_eval File.read("Vagrantfile.local"), "Vagrantfile.local"
  end
end

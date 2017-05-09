  # If such a file exists, load the user's local configuration.
  #
  # This allows developers to extend the Vagrantfile without having to duplicate
  # the entire file.
  if File.exist? "Vagrantfile.config"
    instance_eval File.read("Vagrantfile.config"), "Vagrantfile.config"
  end

# Configure defaults.
MOODLE_DIR = ENV['UBIQUITOUS_MOODLE_DIR'] || MOODLE_DIR || "../Moodle"
# puts "* The value of MOODLE_DIR is '%s'" % [MOODLE_DIR]

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/xenial64"

  config.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh", disabled: true
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "salt", primary: true do |salt|
    salt.vm.network "private_network", ip: "192.168.120.5",
                    netmask: "255.255.255.0"
    salt.vm.hostname = "salt.moodle"

    salt.ssh.port = 2223
    salt.vm.network "forwarded_port", guest: 22, host: salt.ssh.port

    salt.vm.synced_folder ".", "/srv/salt", type: "rsync"
    salt.vm.synced_folder "vagrant/salt/pillar", "/srv/pillar", type: "rsync"
    salt.vm.provision "salt-salt", type: "shell", path: "vagrant/salt/install",
                      args: [ "--master", "app-debug-1,db-pgsql-1,gocd,mail-debug,salt,selenium-hub,selenium-node-chrome,selenium-node-firefox", "--minion", "salt", "--root", "/srv/salt/vagrant/salt" ]
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

    gocd.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    gocd.vm.provision "gocd-salt", type: "shell", path: "vagrant/salt/install", args: [ "--minion", "gocd", "--root", "/vagrant/salt" ]
  end

  config.vm.define "app-debug-1" do |appdebug1|
    appdebug1.vm.network "private_network", ip: "192.168.120.50",
                         netmask: "255.255.255.0"
    appdebug1.vm.hostname = "app-debug-1.moodle"

    appdebug1.ssh.port = 2224
    appdebug1.vm.network "forwarded_port", guest: 22, host: appdebug1.ssh.port

    appdebug1.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    appdebug1.vm.provision "app-debug-1-salt", type: "shell", path: "vagrant/salt/install", args: [ "--minion", "app-debug-1", "--root", "/vagrant/salt" ]

    appdebug1.vm.synced_folder MOODLE_DIR, "/home/ubuntu/releases/vagrant", type: "rsync",
                               owner: "ubuntu", group: "ubuntu",
                               rsync__exclude: [".git", "vendor/", "phpunit.xml"],
                               rsync__rsync_path: "sudo rsync",
                               rsync__args: ["--archive", "--compress", "--delete", "--verbose"]
  end

  config.vm.define "db-pgsql-1" do |db1|
    db1.vm.network "private_network", ip: "192.168.120.150",
                   netmask: "255.255.255.0"
    db1.vm.hostname = "db-pgsql-1.moodle"

    db1.ssh.port = 2225
    db1.vm.network "forwarded_port", guest: 22, host: db1.ssh.port

    db1.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    db1.vm.provision "db-pgsql-1-salt", type: "shell", path: "vagrant/salt/install", args: [ "--minion", "db-pgsql-1", "--root", "/vagrant/salt" ]
  end

  config.vm.define "mail-debug" do |maildebug|
    maildebug.vm.network "private_network", ip: "192.168.120.200"
    maildebug.vm.hostname = "mail-debug.moodle"

    maildebug.ssh.port = 2226
    maildebug.vm.network "forwarded_port", guest: 22, host: maildebug.ssh.port

    maildebug.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    maildebug.vm.provision "mail-debug-salt", type: "shell", path: "vagrant/salt/install", args: [ "--minion", "mail-debug", "--root", "/vagrant/salt" ]
  end

  config.vm.define "selenium-hub" do |seleniumhub|
    seleniumhub.vm.network "private_network", ip: "192.168.120.100",
                           netmask: "255.255.255.0"
    seleniumhub.vm.hostname = "selenium-hub.moodle"

    seleniumhub.ssh.port = 2227
    seleniumhub.vm.network "forwarded_port", guest: 22, host: seleniumhub.ssh.port

    seleniumhub.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    seleniumhub.vm.provision "selenium-hub-salt", type: "shell", path: "vagrant/salt/install", args: ["--minion", "selenium-hub", "--root", "/vagrant/salt" ]
  end

  config.vm.define "selenium-node-chrome" do |seleniumnodechrome|
    seleniumnodechrome.vm.network "private_network", ip: "192.168.120.105",
                                  netmask: "255.255.255.0"
    seleniumnodechrome.vm.hostname = "selenium-node-chrome.moodle"

    seleniumnodechrome.ssh.port = 2228
    seleniumnodechrome.vm.network "forwarded_port", guest: 22, host: seleniumnodechrome.ssh.port

    seleniumnodechrome.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    seleniumnodechrome.vm.provision "selenium-node-chrome-salt", type: "shell", path: "vagrant/salt/install", args: ["--minion", "selenium-node-chrome", "--root", "/vagrant/salt" ]

    seleniumnodechrome.vm.synced_folder MOODLE_DIR, "/home/ubuntu/moodle", type: "rsync",
                                        owner: "ubuntu", group: "ubuntu",
                                        rsync__exclude: ".git/",
                                        rsync__args: ["--rsync-path='sudo rsync'", "--archive", "--compress", "--delete"]
  end

  config.vm.define "selenium-node-firefox" do |seleniumnodefirefox|
    seleniumnodefirefox.vm.network "private_network", ip: "192.168.120.110",
                                   netmask: "255.255.255.0"
    seleniumnodefirefox.vm.hostname = "selenium-node-firefox.moodle"

    seleniumnodefirefox.ssh.port = 2229
    seleniumnodefirefox.vm.network "forwarded_port", guest: 22, host: seleniumnodefirefox.ssh.port

    seleniumnodefirefox.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    seleniumnodefirefox.vm.provision "selenium-node-firefox-salt", type: "shell", path: "vagrant/salt/install", args: ["--minion", "selenium-node-firefox", "--root", "/vagrant/salt" ]

    seleniumnodefirefox.vm.synced_folder MOODLE_DIR, "/home/ubuntu/moodle", type: "rsync",
                                        owner: "ubuntu", group: "ubuntu",
                                        rsync__exclude: ".git/",
                                        rsync__args: ["--rsync-path='sudo rsync'", "--archive", "--compress", "--delete"]
  end

  config.group.groups = {
    "dev" => [
      "salt",
      "app-debug-1",
      "db-pgsql-1",
      "mail-debug",
    ],
    "selenium" => [
      "selenium-hub",
      "selenium-node-chrome",
      "selenium-node-firefox",
    ],
    "pipeline" => [
      "gocd",
    ]
  }

  # If such a file exists, load the user's local configuration.
  #
  # This allows developers to extend the Vagrantfile without having to duplicate
  # the entire file.
  if File.exist? "Vagrantfile.local"
    instance_eval File.read("Vagrantfile.local"), "Vagrantfile.local"
  end
end

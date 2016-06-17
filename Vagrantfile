Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"

  config.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh", disabled: true
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/home/vagrant/sync", disabled: true

  config.ssh.password = "vagrant"

  config.vm.define "salt", primary: true do |salt|
    salt.vm.network "private_network", ip: "192.168.120.5"
    salt.vm.hostname = "salt.moodle"

    salt.ssh.port = 2223
    salt.vm.network "forwarded_port", guest: 22, host: salt.ssh.port

    salt.vm.synced_folder ".", "/srv/salt", type: "rsync"

    salt.vm.provision "salt-salt", type: "shell", path: "vagrant/salt/install", args: [ "--master", "app-debug-1,db-1,mail-debug,salt", "--minion", "salt", "--root", "/srv/salt/vagrant/salt" ]
  end

  config.vm.define "app-debug-1" do |appdebug1|
    appdebug1.vm.network "private_network", ip: "192.168.120.50"
    appdebug1.vm.hostname = "app-debug-1.moodle"

    appdebug1.ssh.port = 2224
    appdebug1.vm.network "forwarded_port", guest: 22, host: appdebug1.ssh.port

    appdebug1.vm.network "forwarded_port", guest: 80, host: 2280

    appdebug1.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    appdebug1.vm.provision "app-debug-1-salt", type: "shell", path: "vagrant/salt/install", args: [ "--minion", "app-debug-1", "--root", "/vagrant/salt" ]

    appdebug1.vm.synced_folder "../moodle", "/home/moodle/htdocs", type: "rsync", owner: 'moodle', group: 'moodle',
                          rsync__exclude: ".git/",
                          rsync__args: ["--rsync-path='sudo rsync'", "--archive", "--compress", "--delete"]
  end

  config.vm.define "db-1" do |db1|
    db1.vm.network "private_network", ip: "192.168.120.150"
    db1.vm.hostname = "db-1.moodle"

    db1.ssh.port = 2225
    db1.vm.network "forwarded_port", guest: 22, host: db1.ssh.port

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

    maildebug.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    maildebug.vm.provision "mail-debug-salt", type: "shell", path: "vagrant/salt/install", args: [ "--minion", "mail-debug", "--root", "/vagrant/salt" ]
  end

  # If such a file exists, load the user's local configuration.
  #
  # This allows developers to extend the Vagrantfile without having to duplicate
  # the entire file.
  if File.exist? "Vagrantfile.local"
    instance_eval File.read("Vagrantfile.local"), "Vagrantfile.local"
  end
end

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

    salt.vm.provision "salt-salt", type: "shell", path: "vagrant/salt/install", args: [ "--master", "app-debug-1,db-1,salt", "--minion", "salt", "--root", "/srv/salt/vagrant/salt" ]

    # salt.vm.provision "salt" do |salt|
    #   salt.install_master = true
    #   salt.master_config = "vagrant/salt/master"
    #   salt.master_key = "vagrant/salt/master.pem"
    #   salt.master_pub = "vagrant/salt/master.pub"

    #   salt.seed_master = {
    #     "app-debug-1" => "vagrant/salt/minions/app-debug-1.pub",
    #     "db-1"  => "vagrant/salt/minions/db-1.pub",
    #     "salt"  => "vagrant/salt/minions/salt.pub"
    #   }

    #   salt.minion_config = "vagrant/salt/minions/salt"
    #   salt.minion_id = "salt"
    #   salt.minion_key = "vagrant/salt/minions/salt.pem"
    #   salt.minion_pub = "vagrant/salt/minions/salt.pub"
    # end
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

    # appdebug1.vm.provision "salt" do |salt|
    #   salt.minion_config = "vagrant/salt/minions/app-debug-1"
    #   salt.minion_id = "app-debug-1"
    #   salt.minion_key = "vagrant/salt/minions/app-debug-1.pem"
    #   salt.minion_pub = "vagrant/salt/minions/app-debug-1.pub"
    # end
  end

  config.vm.define "db-1" do |db1|
    db1.vm.network "private_network", ip: "192.168.120.150"
    db1.vm.hostname = "db-1.moodle"

    db1.ssh.port = 2225
    db1.vm.network "forwarded_port", guest: 22, host: db1.ssh.port

    db1.vm.synced_folder "./vagrant", "/vagrant", type: "rsync"
    db1.vm.provision "db-1-salt", type: "shell", path: "vagrant/salt/install", args: [ "--minion", "db-1", "--root", "/vagrant/salt" ]

    # db1.vm.provision "salt" do |salt|
    #   salt.minion_config = "vagrant/salt/minions/db-1"
    #   salt.minion_id = "db-1"
    #   salt.minion_key = "vagrant/salt/minions/db-1.pem"
    #   salt.minion_pub = "vagrant/salt/minions/db-1.pub"
    # end
  end
end

IP_BASE = "192.168.120."
SALT_PILLAR_DIR = "./_vagrant/salt/pillar"
DEFAULT_ROLES = [
  "admin",
  "hosts",
  "ntp",
  "salt-minion",
  "sshd",
]

def configure_network(v, hostname, ip_offset)
  v.vm.hostname = "#{hostname}.ubiquitous"
  v.vm.network "private_network", ip: "#{IP_BASE}#{ip_offset}", netmask: "255.255.255.0"
end

def provision_master(v)
  v.vm.synced_folder ".", "/srv/salt", type: "rsync"
  v.vm.synced_folder SALT_PILLAR_DIR, "/srv/pillar", type: "rsync"

  v.vm.provision "salt-master", type: "shell", path: "./_vagrant/salt/bootstrap-master",
                 args: [ "--auto-accept-minions" ]
end

def provision_minion(v, master, roles)
  args = [
    "--master", master,
    "--environment", "base",
    "--id", v.vm.hostname,
    "--grain-environment", "dev",
  ]
  (DEFAULT_ROLES + roles).each { |r| args.push("--grain-role", r) }

  v.vm.synced_folder "./_vagrant", "/vagrant", type: "rsync"
  v.vm.provision(
      "salt-install", type: "shell",
      path: "./_vagrant/salt/bootstrap-minion",
      args: args)
  v.vm.provision(
      "salt-wait", type: "shell",
      inline: "until salt-call test.ping; do sleep 1; done")
  v.vm.provision(
      "salt-apply", type: "shell",
      inline: "salt-call --state-output mixed state.apply")
end

Vagrant.configure(2) do |config|
  config.vm.box = "generic/ubuntu1604"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  if Vagrant.has_plugin? "vagrant-hostmanager"
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = false
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
  end

  instance_eval File.read("Vagrantfile.local"), "Vagrantfile.local"
end

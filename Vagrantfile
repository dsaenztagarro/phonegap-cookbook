# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = "phonegap-vm"

  config.ssh.private_key_path = ["~/.vagrant.d/insecure_private_key", "~/.ssh/id_rsa"]
  config.ssh.forward_agent = true

  config.omnibus.chef_version = :latest

  config.vm.box = "opscode_ubuntu-12.04_provisionerless"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, type: "dhcp"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  config.vm.network "forwarded_port", guest: 8000, host: 8080
  config.vm.network "forwarded_port", guest: 8010, host: 8010

  config.vm.provider :virtualbox do |vb|
    vb.name = "phonegap-vm"
    vb.memory = 3072
  end

  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      mysql: {
        server_root_password: 'rootpass',
        server_debian_password: 'debpass',
        server_repl_password: 'replpass'
      }
    }
    chef.run_list = [
        "recipe[phonegap::default]",
    ]
  end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # use the phusion box to avoid HGFS boot hangs and manual intervention
  config.vm.box = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vmwarefusion.box"

  config.vm.provider :vmware_fusion do |v, override|
    v.vmx['memsize'] = 256
  end

  # port numbering starts here
  base_port = 18000

  # redis nodes (x2)
  config.vm.define :redis1, primary: true do |config|
    config.vm.hostname = 'redis1'
    config.vm.network :forwarded_port, guest: 8080, host: base_port + 8080
    config.vm.network :forwarded_port, guest: 80, host: base_port + 8081
    config.vm.network :private_network, ip: "172.28.33.10"

    config.vm.provision :chef_solo do |chef|
      chef.provisioning_path = "/tmp/vagrant-chef"
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "keepalived"
      chef.add_recipe "redis2::auto"
      chef.json = {
        :redis2 => {
          :instances => {
            :primary => {
              :port => 6379,
              :replication => {
                :role => 'master'
              }
            }
          }
        },
      }
    end
  end

  # zookeeper nodes (x3)
  config.vm.define :zk1, primary: true do |config|
    config.vm.hostname = 'zk1'
    config.vm.network :forwarded_port, guest: 2181, host: base_port + 2181
    config.vm.network :private_network, ip: "172.28.33.20"

    config.vm.provision :chef_solo do |chef|
      chef.provisioning_path = "/tmp/vagrant-chef"
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "zookeeperd::server"
      chef.add_recipe "zookeeperd::runit"
      chef.json = {
        :zookeeperd => {
          :cluster => {
            :auto_discovery => false
          },
          :zk_id => 1,
          :init => 'runit'
        }
      }
    end
  end

  config.vm.provision "shell",
    inline: "iptables -F"

end

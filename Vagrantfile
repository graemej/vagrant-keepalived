# -*- mode: ruby -*-
# vi: set ft=ruby :

# defines the cluster shape
load 'cluster.rb'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # use the phusion box to avoid HGFS boot hangs and manual intervention
  config.vm.box = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vmwarefusion.box"

  config.vm.provider :vmware_fusion do |v, override|
    v.vmx['memsize'] = 256
  end

  # redis nodes (x2)
  (1..2).each do |i|
    machine = $cluster.machines["redis#{i}"]
    config.vm.define machine.id, primary: true do |config|
      config.vm.hostname = machine.id
      machine.ports.each {|protocol,ports| config.vm.network :forwarded_port, guest: ports[:guest], host: ports[:host] }
      config.vm.network :private_network, ip: machine.ip

      config.vm.provision :chef_solo do |chef|
        chef.provisioning_path = "/tmp/vagrant-chef"
        chef.cookbooks_path = "cookbooks"
        chef.add_recipe "nginx"
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
          :nginx => {
            :instances => {
              :init_style => 'runit'
            }
          },
          :keepalived => {
            :shared_address => true,
            :check_scripts => {
              :check_redis => {
                :script => '/usr/bin/killall -0 redis-server',
                :interval => 2,
                :weight => 2
              }
            },
            :instances => {
              :vi_1 => {
                :ip_addresses => $cluster.vip,
                :interface => 'eth1',
                :state => 'MASTER',
                :states => {
                  'redis1' => 'MASTER',
                  'redis2' => 'SLAVE',
                },
                :states => {
                  'redis1' => 101,
                  'redis2' => 100,
                },
                :track_script => 'check_redis',
                :nopreempt => false,
                :advert_int => 1,
                :auth_type => :pass,
                :auth_pass => 'secret',
              },
            },
          }
        }
      end
      config.vm.provision "shell",
        inline: "mkdir -p /var/www/nginx-default && echo `hostname` >> /var/www/nginx-default/index.html"
    end
  end

  config.vm.provision "shell",
    inline: "iptables -F"

end

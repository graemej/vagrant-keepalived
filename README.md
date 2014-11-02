# vagrant-keepalived

This is a Vagrant (Chef + VMware Fusion) project to provide a test environment for automatic failover of services using `keepalived`.

The environment consists of the following components:

 * locking: ZooKeeper cluster (3 nodes) to provide coordination
 * service: Redis/nginx servers (2 nodes) primary + fallback
 * test: Talks to and validates the service nodes
 

## notes
* Repeat the provision:
	* sudo chef-solo -c /tmp/vagrant-chef/solo.rb -j /tmp/vagrant-chef/dna.json
 
## references

* redis recipes
* https://github.com/superseb/vagrant-haproxy-vrrp-puppet
* 
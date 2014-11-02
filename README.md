# vagrant-keepalived

This is a Vagrant (Chef + VMware Fusion) project to provide a test environment for automatic failover of services using `keepalived`.

The environment consists of the following components:

 * locking: ZooKeeper cluster (3 nodes) to provide coordination
 * service: Redis/nginx servers (2 nodes) primary + fallback
 
## provisioning

To get the environment up and running:

  1. Clone this repository
  2. Configure your environment: `export VAGRANT_DEFAULT_PROVIDER=vmware_fusion`
  3. Provision with: `vagrant up`
   
To SSH into a particular machine use `vagrant ssh <machine>` where machines are:

<table>
 <thead>
   <tr>
    <td>Machine</td>
    <td>Services</td>
   </tr>
 </thead>
 <tbody>
  <tr>
    <td>redis1 (172.28.33.10)</td>
    <td>
      <ul>
        <li>80: nginx</li>
        <li>6379: redis</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>redis2 (172.28.33.11)</td>
    <td>
      <ul>
        <li>80: nginx</li>
        <li>6379: redis</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>zk1 (172.28.33.12)</td>
    <td>
      <ul>
        <li>2181: zk client</li>
        <li>2888: zk peer</li>
        <li>3888: zk server</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>zk2 (172.28.33.13)</td>
    <td>
      <ul>
        <li>2181: zk client</li>
        <li>2888: zk peer</li>
        <li>3888: zk server</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>zk3 (172.28.33.14)</td>
    <td>
      <ul>
        <li>2181: zk client</li>
        <li>2888: zk peer</li>
        <li>3888: zk server</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td>VIP (<a href='http://172.28.33.15'>172.28.33.15</a>)</td>
    <td>keepalived managed VIP</td>
  </tr>
 </thead>
</table>   

## testing

* Each `nginx` instance has been configured to display the name of the host on the index page.  Visit: <a href='http://172.28.33.15'>172.28.33.15</a> and you should see `redis1` as the initial master.

* Do evil things to the services/machines (e.g. `vagrant halt redis1` and you should see the VIP fail over to `redis2`).

* To see the status of zookeeper nodes you can use the four-letter words: e.g. `echo status | nc <zookeeper-ip> 2181` should show something like:

```
echo status | nc 172.28.33.14 2181
Zookeeper version: 3.4.5--1, built on 06/10/2013 17:26 GMT
Clients:
 /172.28.33.1:63775[0](queued=0,recved=1,sent=0)

Latency min/avg/max: 0/0/0
Received: 1
Sent: 0
Connections: 1
Outstanding: 0
Zxid: 0x200000000
Mode: follower
Node count: 4
```



## notes
* To repeat the provision:
	* sudo chef-solo -c /tmp/vagrant-chef/solo.rb -j /tmp/vagrant-chef/dna.json
* see also inspiration from: https://github.com/superseb/vagrant-haproxy-vrrp-puppet 
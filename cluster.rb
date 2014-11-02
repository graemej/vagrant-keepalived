class Machine
  attr_accessor :id, :ip, :base_port, :ports

  def initialize(id, base_port)
    @id = id
    @base_port = base_port
    @ports = {}
  end

  def expose(protocol, port)
    @ports[protocol] = {:guest => port, :host => @base_port + port}
  end
end

class Cluster
  attr_accessor :machines, :vip

  def initialize()
    @base_port = (ENV['BASE_PORT'] || '10000').to_i
    @next_port = @base_port
    @machines = {}
  end

  def next_port()
    port = @next_port
    @next_port += 10000
    port
  end

  def expose(machine, protocol, port)
    machine = @machines[machine] ||= Machine.new(machine, self.next_port)
    machine.expose(protocol, port)
  end

  def inspect()
    s = ""
    s << "Cluster { vip: #{@vip}\n"
    @machines.each do |id,machine|
      s << "  #{id} (base: #{machine.base_port}, ip: #{machine.ip})\n"
      machine.ports.each do |protocol,ports|
      s << "    #{protocol} (guest: #{ports[:guest]} host: #{ports[:host]})\n"
      end
    end
    s << "}\n"
    s
  end
end

$cluster = Cluster.new
octet = 10
(1..2).each do |i|
  hostname = "redis#{i}"
  $cluster.expose(hostname,"http-1", 80)
  $cluster.expose(hostname,"redis", 6379)
  $cluster.machines[hostname].ip = "172.28.33.#{octet}"
  octet += 1
end

(1..3).each do |i|
  hostname = "zk#{i}"
  $cluster.expose("zk#{i}","zk-client", 2181)
  $cluster.expose("zk#{i}","zk-peer", 2888)
  $cluster.expose("zk#{i}","zk-server", 3888)
  $cluster.machines[hostname].ip = "172.28.33.#{octet}"
  octet += 1
end

$cluster.vip = "172.28.33.#{octet}"
puts $cluster.inspect

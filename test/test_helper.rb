require 'minitest'
require 'net/http'
require 'pry'
require 'minitest/autorun'
require 'redis'

def vip_address
  "172.28.33.15"
end

def redis_port
  6379
end

def check_host
  Net::HTTP.get(URI.parse("http://#{vip_address}")).chomp
end

def redis_client
  @redis = @redis || Redis.new(:host => vip_address, :port => redis_port)
end

def check_redis_up?
  redis_client.ping == 'PONG'
end

def redis_set(key, value)
  redis_client.set(key, value)
end

def redis_get(key)
  redis_client.get(key)
end

def redis_flushdb()
  redis_client.flushdb
end
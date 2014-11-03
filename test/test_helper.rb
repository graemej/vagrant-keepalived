require 'minitest'
require 'net/http'
require 'pry'
require 'minitest/autorun'

def vip_address
  "172.28.33.15"
end

def redis_port
  6379
end

def check_host
  Net::HTTP.get(URI.parse("http://#{vip_address}")).chomp
end

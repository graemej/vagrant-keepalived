require 'test_helper'

class FailOverTest < MiniTest::Test
  def setup
  end

  def test_initial
    assert_equal "redis1", check_host
  end

  def test_redis_up
    assert check_redis_up?
  end

  def test_redis_key_set
    begin
      assert_equal 'OK', redis_set('foo', 'bar')
    ensure
      redis_flushdb
    end
  end

  def test_redis_key_get
    begin
      redis_set('foo', 'bar')
      assert_equal 'bar', redis_get('foo')
    ensure
      redis_flushdb
    end
  end

  def test_redis_flushdb
    redis_set('foo', 'bar')
    redis_flushdb
    assert_nil redis_get('foo')
  end
end

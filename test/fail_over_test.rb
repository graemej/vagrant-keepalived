require 'test_helper'

class FailOverTest < MiniTest::Test
  def setup
  end

  def test_initial
    assert_equal "redis1", check_host
  end
end

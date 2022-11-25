require "minitest/autorun"

class MainTest < Minitest::Test
  def setup
  end

  def test_something
    assert_equal 4, 2+2
  end

  def test_skipped
    skip 'gonna run this later'
  end
end

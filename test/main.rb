require "minitest/autorun"
require_relative 'models/dels/Argument'
require_relative '../lib/init'

class MainTest < Minitest::Test
  def setup
  end

  def test_something
    assert_equal 4, 2+2
  end
end

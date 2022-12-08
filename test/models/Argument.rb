require "minitest/autorun"
require_relative '../../lib/models/Arguments'

class ArgumentModelTest < Minitest::Test
  def test_parses_prompt
    arguments = Arguments.new 'record new'
    assert_equal arguments.prompt, 'record'

    arguments = Arguments.new 'record       new'
    assert_equal arguments.prompt, 'record'

    arguments = Arguments.new 'record'
    assert_equal arguments.prompt, 'record'
  end

  def test_parses_command
    arguments = Arguments.new 'record new'
    assert_equal arguments.command, 'new'

    arguments = Arguments.new 'r         new'
    assert_equal arguments.command, 'new'
  end

  def test_parses_kwargs
    arguments = Arguments.new 'record list created=desc monthly=1,2,3'
    assert arguments.kwargs[:created] == 'desc'
    assert arguments.kwargs[:monthly] == '1,2,3'
  end

  def test_parses_int_args
    arguments = Arguments.new 'record edit 0'
    assert arguments.int_args.first == 0

    arguments = Arguments.new 'record edit 0 1 4'
    assert arguments.int_args[0] == 0
    assert arguments.int_args[1] == 1
    assert arguments.int_args[2] == 4
  end

  def test_parses_string_args
    arguments = Arguments.new 'record edit un'
    assert arguments.string_args.first == 'un'

    arguments = Arguments.new 'record edit un do twa'
    assert arguments.string_args[0] == 'un'
    assert arguments.string_args[1] == 'do'
    assert arguments.string_args[2] == 'twa'
  end
end

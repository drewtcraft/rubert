class State
  # persists temp data between prompts

  attr_accessor :args, :last_record_list, :last_task_list, :last_commands

  def initialize(params = {})
    @last_commands = []

    @args = nil
    @last_record_list = nil
    @last_task_list = nil
  end

  def has_args?
    @args != nil
  end

  def has_last_record_list?
    @last_record_list != nil
  end

  def has_last_task_list?
    @last_task_list != nil
  end

  def soft_reset!
    @args = nil
  end

  def hard_reset!
    soft_reset
    @last_record_list = nil
    @last_task_list = nil
  end

  def append_command!(c)
    @last_commands << c
  end

  def extract_args_from_command!(c)
    # remove first two words, the rest are arguments (<domain> <command> <argument>)
    argument_string = c.sub(/^[^\s]+\s+[^\s]+\s/, '')
    @args = argument_string.split(' ').inject({}) do |hash, argument|
      if argument.match(/[^\s]=/)
        unless hash.has_key? :keyword_arguments
          hash[:keyword_arguments] = {}
        end
        key, value = argument.split('=')
        hash[:keyword_arguments][key.to_s] = value
      elsif argument.match(/^\d+$/)
        hash[:int_arg] = argument.to_i
      else
        hash[:string_arg] = argument
      end
      hash
    end
  end
end

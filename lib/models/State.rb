require_relative 'Arguments'

class State
  # persists temp data between prompts

  attr_accessor :last_record_list, :last_task_list, :last_ledger_list, :is_first_run, :ledger, :config
  attr_reader :last_commands

  def initialize()
    @ledger = nil
    @config = nil
    @last_commands = []

    @last_ledger_list = nil
    @last_record_list = nil
    @last_task_list = nil
  end

  def get_resource_by_index(type, index)
    case type
    when :ledger
      @last_ledger_list[index]
    when :record
      @last_record_list[index]
    when :task
      @last_task_list[index]
    end
  end

  def soft_reset!
    @last_ledger_list = nil
    @last_record_list = nil
    @last_task_list = nil
  end

  def append_command!(c)
    @last_commands << c
  end
end

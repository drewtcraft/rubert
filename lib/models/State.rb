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

  def soft_reset!
    @last_ledger_list = nil
    @last_record_list = nil
    @last_task_list = nil
  end

  def append_command!(c)
    @last_commands << c
  end
end

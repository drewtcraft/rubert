require_relative 'Arguments'

class State
  # persists temp data between prompts

  attr_accessor :last_record_list, :last_task_list, :is_first_run, :ledger
  attr_reader :last_commands, :config

  def initialize(params = {})
    @ledger = params[:ledger]
    @config = params[:config]
    @last_commands = []

    @last_ledger_list = nil
    @last_record_list = nil
    @last_task_list = nil
    @is_first_run = true
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
    @arguments = nil
  end

  def hard_reset!
    soft_reset!
    @last_record_list = nil
    @last_task_list = nil
    @last_ledger_list = nil
    @is_first_run = true
  end

  def append_command!(c)
    @last_commands << c
  end
end

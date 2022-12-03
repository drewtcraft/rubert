class State
  # persists temp data between prompts

  attr_accessor :last_record_list, :last_task_list, :is_first_run, :ledger
  attr_reader :arg_string, :last_commands

  def initialize(params = {})
    @ledger = params[:ledger]
    @last_commands = []

    @arg_string = nil
    @last_record_list = nil
    @last_task_list = nil
    @is_first_run = true
  end

  def has_last_record_list?
    @last_record_list != nil
  end

  def has_last_task_list?
    @last_task_list != nil
  end

  def has_arg_string?
    @arg_string != nil
  end

  def soft_reset!
    @arg_string = nil
  end

  def hard_reset!
    soft_reset
    @last_record_list = nil
    @last_task_list = nil
    @is_first_run = true
  end

  def append_command!(c)
    @arg_string = c
    @last_commands << c
  end
end

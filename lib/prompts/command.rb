require_relative './base'

module CommandPrompt
  module CommandRegExp
    EXIT = /^\s?exit/i
    QUIT = /^\s?quit/i
    HELP = /^\s?help/i
    HISTORY = /^\s?his(?:tory)?/

    TASK_NEW = /^\s?t(?:ask)?\snew/i
    TASK_LIST = /^\s?t(?:ask)?\slist/i
    TASK_DONE = /^\s?t(?:ask)?\sdone/i
    TASK_EDIT = /^\s?t(?:ask)?\sedit/i
    TASK_DEL = /^\s?t(?:ask)?\sdel/i

    RECORD_NEW = /^\s?rec(?:ord)?\snew/i
    RECORD_LIST = /^\s?rec(?:ord)?\slist/i
    RECORD_SHOW = /^\s?rec(?:ord)?\sshow/i
    RECORD_EDIT = /^\s?rec(?:ord)?\sedit/i
    RECORD_DEL = /^\s?rec(?:ord)?\sdel/i

    LEDGER_NEW = /^\s?le(?:dger)?\snew/i
    LEDGER_SHOW = /^\s?le(?:dger)?\sshow/i
    LEDGER_LIST = /^\s?le(?:dger)?\slist/i
    LEDGER_SWITCH = /^\s?le(?:dger)?\sswitch/i
    LEDGER_DEL = /^\s?le(?:dger)?\sdel/i
  end

  class CommandPrompt < Prompt
    def process
      super

      # could pass in a fake argument string here??? is that too hacky?
      if @state.is_first_run
        Output.log "current ledger \"#{@state.ledger.name}\""
        Output.puts "enter COMMAND (\"help\" for list of commands):"
        @state.is_first_run = false
      else
        Output.puts "enter COMMAND:"
      end

      input = Input.gets

      @state.append_command! input
      @next_prompt_type = case input
      when CommandRegExp::EXIT, CommandRegExp::QUIT
        :exit
      when CommandRegExp::HELP
        :help
      when CommandRegExp::HISTORY
        :history

      when CommandRegExp::LEDGER_NEW
        :ledger_new
      when CommandRegExp::LEDGER_SHOW
        :ledger_show
      when CommandRegExp::LEDGER_LIST
        :ledger_list
      when CommandRegExp::LEDGER_SWITCH
        :ledger_switch
      when CommandRegExp::LEDGER_DEL
        :ledger_delete

      when CommandRegExp::RECORD_NEW
        :record_new
      when CommandRegExp::RECORD_SHOW
        :record_show
      when CommandRegExp::RECORD_LIST
        :record_list
      when CommandRegExp::RECORD_EDIT
        :record_edit
      when CommandRegExp::RECORD_DEL
        :record_delete

      when CommandRegExp::TASK_NEW
        :task_new
      when CommandRegExp::TASK_LIST
        :task_list
      when CommandRegExp::TASK_DONE
        :task_done
      when CommandRegExp::TASK_EDIT
        :task_edit
      when CommandRegExp::TASK_DEL
        :task_delete

      else
        if input == ""
          input = "<empty-string>"
        end
        Output.puts "#{input} is not a command, try typing \"help\""
        :command
      end
    end
  end

  MAPPINGS = {command: CommandPrompt}
end

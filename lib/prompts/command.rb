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
    LEDGER_LIST = /^\s?le(?:dger)?\slist/i
    LEDGER_SWITCH = /^\s?le(?:dger)?\sswitch/i
    LEDGER_DEL = /^\s?le(?:dger)?\sdel/i
  end

  class CommandPrompt < Prompt
    TITLE = 'COMMAND'
    def self.next_prompt_type(ledger, state)
      super

      Output.puts_indented "current ledger \"#{ledger.name}\""
      Output.puts_dashes
      Output.puts "enter COMMAND (\"help\" for list of commands):"

      input = gets

      state.append_command! input
      state.extract_args_from_command! input
      Output.puts_newline
      Output.puts_dashes

      case input
      when CommandRegExp::EXIT, CommandRegExp::QUIT
        :exit
      when CommandRegExp::HELP
        :help
      when CommandRegExp::HISTORY
        :history

      when CommandRegExp::RECORD_NEW
        :record_new
      when CommandRegExp::RECORD_SHOW
        :record_show
      when CommandRegExp::RECORD_LIST
        :record_list
      when CommandRegExp::RECORD_EDIT
        :record_edit
      when CommandRegExp::RECORD_DEL
        :record_del

      when CommandRegExp::TASK_NEW
        :task_new
      when CommandRegExp::TASK_LIST
        :task_list
      when CommandRegExp::TASK_DONE
        :task_done
      when CommandRegExp::TASK_EDIT
        :task_edit
      when CommandRegExp::TASK_DEL
        :task_del

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

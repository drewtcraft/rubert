require_relative './base'

module CommandRegExp
  EXIT = /^\s?exit/i
  QUIT = /^\s?quit/i
  RECORD_NEW = /^\s?rec[ord]?\s?new/i
  LEDGER_NEW = /^\s?le[dger]?\s?new/i
  HELP = /^\s?help/i
end

class CommandPrompt < Prompt
  def get_next_prompt
    Printer.puts_indented "current ledger \"#{@ledger.name}\""
    Printer.puts_dashes
    puts "COMMAND"
    puts "enter COMMAND (\"help\" for list of commands):"
    input = gets
    Printer.puts_newline
    Printer.puts_dashes

    case input
    when CommandRegExp::EXIT, CommandRegExp::QUIT
      exit 0
    when CommandRegExp::RECORD_NEW
      :new_record
    when CommandRegExp::HELP
      Printer.clear
      puts '"r[ec[ord]] [new|list]", "exit", "quit"'
      self.class
    else
      puts "#{input} is not a command, try typing \"help\""
      self.class
    end
  end
end

require_relative '../helpers/output'
require_relative 'utils'

class Prompt
  def self.translate_command(command)
    case command
    when CommandRegExp::NEW
      :create
    when CommandRegExp::SHOW
      :show
    when CommandRegExp::LIST
      :list
    when CommandRegExp::EDIT
      :edit
    when CommandRegExp::DELETE
      :delete
    when CommandRegExp::SWITCH
      :switch
    when CommandRegExp::DONE
      :done
    when CommandRegExp::HELP
      :help
    else
      :show
    end
  end

  def self.confirmed?(msg)
    Output.puts "#{msg} (y/n)"
    Input.gets == 'y'
  end
end

class HelpPrompt < Prompt
  REGEXP = /^help$/

  def self.show(state, arguments)
    Output.log 'available commands'
    Output.puts_dashes
    Output.puts '[exit|quit]'
    Output.puts 'his(tory)'
    Output.puts 'rec(ord)'.ljust(10) + '[new|list|show|edit|del|help]'
    Output.puts 't(ask)'.ljust(10) + '[new|list|done|show|edit|del|help]'
    Output.puts 'le(dger)'.ljust(10) + '[new|list|switch|show|del|help]'
    Output.puts_dashes
  end
end

class HistoryPrompt < Prompt
  REGEXP = /^his(?:tory)?$/

  def self.show(state, arguments)
    Output.log 'last 10'
    Output.puts_dashes
    state.last_commands.each {|cmd| Output.puts cmd}
    Output.puts_dashes
  end
end

class ExitPrompt < Prompt
  REGEXP = /^(exit|quit)$/

  def self.show(state, arguments)
    exit 0
  end
end
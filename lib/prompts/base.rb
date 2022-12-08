require_relative '../helpers/output'
require_relative 'utils'

class Prompt
  def self.process(state, arguments)
    case arguments.command
    when CommandRegExp::NEW
      create(state, arguments)
    when CommandRegExp::SHOW
      show(state, arguments)
    when CommandRegExp::LIST
      list(state, arguments)
    when CommandRegExp::EDIT
      edit(state, arguments)
    when CommandRegExp::DELETE
      delete(state, arguments)
    when CommandRegExp::HELP
      help(state, arguments)
    else
      raise NoMethodError
    end

  rescue NoMethodError
    Output.error "#{arguments.command} not found"
  end

  def self.confirmed?(msg)
    Output.puts "#{msg} (y/n)"
    Input.gets == 'y'
  end
end

module GeneralPrompt
  class ExitPrompt < Prompt
    TITLE = 'EXITING'
    def process
      super
      exit 0
    end
  end

  class HelpPrompt < Prompt
    TITLE = 'HELP'
    def process
      super
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
    TITLE = 'HISTORY'
    def process
      super
      Output.log 'last 10'
      Output.puts_dashes
      @state.last_commands.each {|cmd| Output.puts cmd}
      Output.puts_dashes
    end
  end

  MAPPINGS = {
    exit: ExitPrompt,
    quit: ExitPrompt,
    history: HistoryPrompt,
    help: HelpPrompt,

  }
end

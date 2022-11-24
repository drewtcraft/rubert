require_relative '../helpers/printer'

class Prompt
  TITLE = 'something went wrong'

  def self.next_prompt_type(ledger=nil, state=nil)
    Printer.puts_prompt_title self::TITLE
    :exit
  end
end

module GeneralPrompt
  class ExitPrompt < Prompt
    TITLE = "EXITING"
    def self.next_prompt_type(ledger, state)
      super and exit 0
    end
  end

  class HelpPrompt < Prompt
    TITLE = "HELP"
    def self.next_prompt_type(ledger, state)
      super
      puts "AVAILABLE COMMANDS"
      Printer.log "[exit|quit]"
      Printer.log "his(tory)"
      Printer.log "rec(ord) [new|list|edit|del]"
      Printer.log "le(dger) [new|switch|del]"
      :command
    end
  end

  class HistoryPrompt < Prompt
    TITLE = "HISTORY"
    def self.next_prompt_type(ledger, state)
      super
      Printer.log "last 10"
      state[:last_commands].each {|cmd| puts cmd}
      :command
    end
  end

  MAPPINGS = {

  }
end

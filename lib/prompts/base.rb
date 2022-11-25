require_relative '../helpers/output'

class Prompt
  TITLE = nil

  def self.next_prompt_type(ledger=nil, state=nil)
    if self::TITLE 
      Output.puts_prompt_title self::TITLE
    end
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
      Output.log "[exit|quit]"
      Output.log "his(tory)"
      Output.log "rec(ord) [new|list|edit|del]"
      Output.log "le(dger) [new|switch|del]"
      :command
    end
  end

  class HistoryPrompt < Prompt
    TITLE = "HISTORY"
    def self.next_prompt_type(ledger, state)
      super
      Output.log "last 10"
      state[:last_commands].each {|cmd| puts cmd}
      :command
    end
  end

  MAPPINGS = {

  }
end

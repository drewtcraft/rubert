require_relative './base'

module LedgerPrompt
  class New < Prompt
    TITLE = "NEW LEDGER"
    def process
      super
      Output.puts "input ledger name"
      ledger_file_name = "#{ledger_name}.yml"

      if not File.exists? ledger_file_name
        new_ledger = Ledger.from_name ledger_name
        new_ledger.write!
        Output.log "created and saved new ledger \"#{ledger_name}\""
        new_ledger
      :command
    end
  end
  
  class Show < Prompt
    TITLE = "SHOW LEDGER"
    def process
      super
      raise
      :command
    end
  end

  class List < Prompt
    TITLE = "LIST LEDGERS"
    def process
      super
      raise
      :command
    end
  end

  class Switch < Prompt
    TITLE = "SWITCH LEDGERS"
    def process
      super
      raise
      :command
    end
  end

  class Delete < Prompt
    TITLE = "DELETE LEDGER"
    def process
      super
      raise
      :command
    end
  end

  MAPPINGS = {
    ledger_new: New,
    ledger_show: Show,
    ledger_list: List,
    ledger_switch: Switch,
    ledger_delete: Delete,
  }
end

# frozen_string_literal: true

require_relative './base'

module LedgerPrompt
  # what if there was one class
  # ledgerhandler
  # and it had a create, update, list, etc??
  class New < Prompt
    TITLE = 'NEW LEDGER'
    def process
      super
      Output.puts 'input new ledger name'
      ledger_name = Input.gets
      ledger_file_name = "#{@state.config.base_directory}#{ledger_name}.yml"

      if File.exist? ledger_file_name
        Output.error "ledger #{ledger_name} already exists"
      else
        new_ledger = Ledger.from_name ledger_name
        new_ledger.write!
        Output.log "created and saved new ledger \"#{ledger_name}\""
        @state.ledger = new_ledger if confirmed? 'switch to new ledger?'
      end
    end
  end

  class Show < Prompt
    TITLE = 'SHOW LEDGER'
    include GetLedgerName
    def process
      super
      raise
      :command
    end
  end

  class List < Prompt
    TITLE = 'LIST LEDGERS'
    def process
      super
      ledgers = Dir.entries(@state.config.base_directory)
                   .select { |f| f.match(/\.yml$/) }
                   .map{ |f| f.split('.')[0..-2].join('') }

      Output.puts_between_lines do
        ledgers.each_with_index { |l, i| Output.puts_list_ledger(l, i) }
      end
    end
  end

  module GetLedgerName
    def get_ledger_name()
      string_args = @state.arguments.string_args, @state.arguments.int_args
      if int_args.any?
        index = int_args.first
        Output.log "looking for ledger with list index: #{index}"
        @state.get_resource_by_index(:ledger, index)
      elsif string_args.any?
        string_args.first
      end
    end
  end

  class Switch < Prompt
    TITLE = 'SWITCH LEDGERS'
    include GetLedgerName
    def process
      super
      ledger_name = get_ledger_name
      if Ledger.file_exists? ledger_name
        Ledger.from_file ledger_name
      else
        Output.error 'no ledger found!'
      end
    end

  end

  class Delete < Prompt
    TITLE = 'DELETE LEDGER'
    include GetLedgerName
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
    ledger_delete: Delete
  }.freeze
end

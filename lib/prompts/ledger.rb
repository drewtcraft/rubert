# frozen_string_literal: true

require_relative './base'

class LedgerPrompt < Prompt
  REGEXP = /^le(?:dger)?/.freeze
  def self.create(state, arguments)
    Output.puts 'input new ledger name'
    ledger_name = Input.gets
    ledger_file_name = "#{state.config.base_directory}#{ledger_name}.yml"

    if File.exist? ledger_file_name
      Output.error "ledger #{ledger_name} already exists"
    else
      new_ledger = Ledger.from_name ledger_name
      new_ledger.write!
      Output.log "created and saved new ledger \"#{ledger_name}\""
      state.ledger = new_ledger if confirmed? 'switch to new ledger?'
    end
  end

  def self.show(state, arguments)

  end

  def self.list(state, arguments)
    ledgers = Dir.entries(state.config.base_directory)
                 .select { |f| f.match(/\.yml$/) }
                 .map{ |f| f.split('.')[0..-2].join('') }

    Output.puts_between_lines do
      ledgers.each_with_index { |l, i| Output.puts_list_ledger(l, i) }
    end
  end

  def self.switch(state, arguments)
    ledger_name = get_ledger_name
    if Ledger.file_exists? ledger_name
      Ledger.from_file ledger_name
    else
      Output.error "ledger \"#{ledger_name}\" does not exist"
    end
  end

  def self.delete(state, arguments)

  end

  def self.help(state, arguments)

  end

  private
  def get_ledger_name(state, arguments)
    string_args = arguments.string_args, arguments.int_args
    if int_args.any?
      index = int_args.first
      Output.log "looking for ledger with list index: #{index}"
      state.get_resource_by_index(:ledger, index)
    elsif string_args.any?
      string_args.first
    end
  end
end

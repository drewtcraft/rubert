# frozen_string_literal: true

require_relative '../models/Ledger'
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
      new_ledger = Ledger.new_from_name(ledger_name, state.config.base_directory)
      new_ledger.write!
      Output.log "created and saved new ledger \"#{ledger_name}\""
      state.ledger = new_ledger if confirmed? 'switch to new ledger?'
    end
  end

  def self.backup(state, arguments)
    Persistence.backup_ledgers! state.config.base_directory
  end

  def self.show(state, arguments)
    ledger_name = get_ledger_name(state, arguments)
    unless Ledger.file_exists?(ledger_name, state.config.base_directory)
      Output.error "ledger \"#{ledger_name}\" does not exist"
    end
    ledger = Ledger.from_file(ledger_name, state.config.base_directory)
    Output.puts_underlined ledger_name
    Output.puts 'last records'
    Output.puts_between_lines do
      ledger.records[-3..].each { |r| Output.puts "#{r.body}" }
      state.config.write!
    end
    Output.puts 'last tasks'
    Output.puts_between_lines do
      ledger.tasks[-4..].each { |t| Output.puts t.body}
    end
  end

  def self.ensure(state, arguments)
    ledger_name = if state.config.last_ledger_name
                    state.config.last_ledger_name
                  else
                    Output.puts 'enter new ledger name'
                    Input.gets
                  end

    state.ledger = if Ledger.file_exists?(ledger_name, state.config.base_directory)
                     Output.log "ledger \"#{ledger_name}\" loaded from memory"
                     Ledger.new_from_name(ledger_name, state.config.base_directory)
                   else
                     new_ledger = Ledger.new_from_name(ledger_name, state.config.base_directory)
                     new_ledger.write!
                     Output.log "created and saved new ledger \"#{ledger_name}\""
                     new_ledger
                   end
  end

  def self.list(state, arguments)
    ledgers = Dir.entries(state.config.base_directory)
                 .select { |f| f.match(/\.yml$/) }
                 .map{ |f| f.split('.')[0..-2].join('') }

    state.last_ledger_list = ledgers

    Output.puts_between_lines do
      ledgers.each_with_index { |l, i| Output.puts_list_ledger(l, i) }
    end
  end

  def self.switch(state, arguments)
    ledger_name = get_ledger_name(state, arguments)
    if Ledger.file_exists?(ledger_name, state.config.base_directory)
      state.ledger = Ledger.from_file(ledger_name, state.config.base_directory)
      state.config.last_ledger_name = ledger_name
      state.config.write!
      state.soft_reset!
    else
      Output.error "ledger \"#{ledger_name}\" does not exist"
    end
  end

  def self.delete(state, arguments)
    ledger_name = get_ledger_name(state, arguments)
    if Ledger.file_exists?(ledger_name, state.config.base_directory)
      if confirmed? "delete ledger #{ledger_name}?"
        Persistence.delete_ledger!(ledger_name, state.config.base_directory)
      end
    end

  end

  def self.help(state, arguments)

  end

  private
  def self.get_ledger_name(state, arguments)
    if arguments.int_args.any?
      state.last_ledger_list[arguments.int_args.first]
    elsif arguments.string_args.any?
      arguments.string_args.first
    else
      state.ledger.name
    end
  end
end

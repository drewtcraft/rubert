require_relative 'helpers/input'
require_relative 'helpers/output'
require_relative 'prompts/main'
require_relative 'helpers/output'
require_relative 'models/Ledger'
require_relative 'models/State'
require_relative 'models/Config'
require 'yaml'
require 'debug'

def print_title
  Output.clear
  Output.puts_in_box "RUBERT"
  Output.puts_newline
end

def create_new_config
  Output.log 'config.yml not found'
  Output.log 'creating config.yml'

  Output.puts_underlined 'SETUP'
  Output.puts 'enter the default path to store files, or leave blank to store in repo'
  base_directory = Input.gets.strip
  base_directory = '../ledgers/' if base_directory == ''
  unless File.exist? base_directory
    Dir.mkdir base_directory
  end

  Output.puts 'enter a ledger name (e.g. "JOURNAL")'
  ledger_name = Input.gets.strip

  config = Config.new(last_ledger_name: ledger_name, base_directory:)
  config.write!
  config
end


def ensure_config
  if Config.file_exists?
    Config.from_file
  else
    create_new_config
  end
end

def ensure_ledger(ledger_name)
  if Ledger.file_exists? ledger_name
    Output.log "ledger \"#{ledger_name}\" loaded from memory"
    Ledger.from_file ledger_name
  else
    new_ledger = Ledger.new_from_name ledger_name
    new_ledger.write!
    Output.log "created and saved new ledger \"#{ledger_name}\""
    new_ledger
  end
end

def init
  print_title
  config = ensure_config
  ledger = ensure_ledger config.last_ledger_name
  state = State.new(ledger:, config:)

  loop do
    Output.puts "enter command:"
    input = Input.gets

    arguments = Arguments.new input
    # Output.puts arguments
    state.append_command! input

    prompt_str = arguments.prompt
    prompt = PROMPTS.find { |p| prompt_str.match(p::REGEXP) }
    begin
      prompt.send arguments.command, state, arguments
    rescue NoMethodError
      Output.error "\"#{prompt_str} #{arguments.command}\" just don't make no sense."
    end
  end
end

init

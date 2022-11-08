require_relative 'prompts/prompts'
require_relative 'helpers/printer'
require_relative 'models/Ledger'
require 'yaml'

CONFIG_FILE_NAME = 'config.yml'

def print_title
  Printer.clear
  Printer.puts_in_box "RUBERT"
  Printer.puts_newline
end

def get_ledger_name()
  if not File.exists? CONFIG_FILE_NAME
    Printer.log 'config.yml not found'
    Printer.log 'creating config.yml'
    puts 'enter a ledger name (e.g. "JOURNAL")'
    _ledger_name = gets.strip
    _config = {
      last_ledger_name: _ledger_name
    }
    File.open(CONFIG_FILE_NAME, 'w') do |h| 
       h.write _config.to_yaml
    end
    _ledger_name
  else
    _config = YAML.load_file CONFIG_FILE_NAME
    _config[:last_ledger_name]
  end
end

def ensure_ledger
  ledger_name = get_ledger_name
  ledger_file_name = "#{ledger_name}.yml"

  if not File.exists? ledger_file_name
    new_ledger = Ledger.from_name ledger_name
    new_ledger.write
    Printer.log "created and saved new ledger \"#{ledger_name}\""
    new_ledger
  else
    Printer.log "ledger \"#{ledger_name}\" loaded from memory"
    Ledger.from_file ledger_file_name
  end
end

def init
  print_title
  ledger = ensure_ledger

  Printer.puts_newline

  prompt = CommandPrompt
  loop do
    prompt_instance = prompt.new(ledger)
    prompt_type = prompt_instance.get_next_prompt
    prompt = PROMPTS[prompt_type]
  end
end

init

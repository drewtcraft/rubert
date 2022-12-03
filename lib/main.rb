require_relative 'prompts/main'
require_relative 'helpers/output'
require_relative 'models/Ledger'
require_relative 'models/State'
require 'yaml'

CONFIG_FILE_NAME = 'config.yml'

def print_title # TODO aka welcomeprompt
  Output.clear
  Output.puts_in_box "RUBERT"
  Output.puts_newline
end

# TODO move all this logic to prompts??
def get_ledger_name()
  if not File.exists? CONFIG_FILE_NAME
    Output.log 'config.yml not found'
    Output.log 'creating config.yml'
    puts 'enter a ledger name (e.g. "JOURNAL")'
    _ledger_name = Input.gets.strip
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
    new_ledger.write!
    Output.log "created and saved new ledger \"#{ledger_name}\""
    new_ledger
  else
    Output.log "ledger \"#{ledger_name}\" loaded from memory"
    Ledger.from_file ledger_name
  end
end

def init
  print_title
  ledger = ensure_ledger

  state = State.new ledger:
  prompt_type = :command
  loop do
    prompt_ctor = PROMPTS[prompt_type]
    prompt = prompt_ctor.new state
    prompt.process
    prompt_type = prompt.next_prompt_type
  end
end

init

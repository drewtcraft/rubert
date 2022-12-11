require_relative 'helpers/input'
require_relative 'helpers/output'
require_relative 'prompts/main'
require_relative 'models/State'
require 'yaml'
require 'debug'

def init
  Output.print_title

  state = State.new
  loop do
    input = if state.config.nil?
              'config ensure'
            elsif state.ledger.nil?
              'ledger ensure'
            else
              Output.puts_newline
              Output.puts "[#{state.ledger.name}] enter command:"
              Input.gets
            end

    arguments = Arguments.new input
    state.append_command! input

    prompt_str = arguments.prompt
    prompt = PROMPTS.find { |p| prompt_str.match(p::REGEXP) }
    begin
      prompt.send arguments.command, state, arguments
    rescue NoMethodError => e
      Output.error e
      Output.error "\"#{prompt_str} #{arguments.command}\" just don't make no sense."
    end
  end
end

init

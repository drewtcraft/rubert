require_relative 'utils'
require_relative '../helpers/printer'
require 'yaml'
require_relative './command'
require_relative './record'
require_relative './base'

PROMPTS = {
  command: CommandPrompt,
  new_record: NewRecordPrompt
}

class NewLedgerPrompt < Prompt
  def get_next_prompt
    puts "enter ledger name"
    # create and switch to space
    CommandPrompt
  end
end


# prompts:
# command
# create record-space, becomes default
# switch record-space
# list record-space
# record (to main)
# tag record (to main)
# list
# list by tag
# list by query
#
#

require_relative 'prompts/prompts'
require_relative 'helpers/printer'

Printer.print_title "welcome to this shit"

prompt = CommandPrompt
state = {}
loop do
  prompt_instance = prompt.new(state)
  prompt = prompt_instance.get_next_prompt
end


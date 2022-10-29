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

class Putter
  #singleton
#  def put(str, indent=
end

def put_break(l=20)
  puts '-' * l
end

def put_newline
  puts "\n"
end


prompt = CommandPrompt
state = {}
loop do
  prompt_instance = prompt.new(state)
  prompt = prompt_instance.get_next_prompt
end


# require_relative 'command'
require_relative 'record'
# require_relative 'ledger'
# require_relative 'task'

# PROMPTS = {
#   **GeneralPrompt::MAPPINGS,
#   **CommandPrompt::MAPPINGS,
#   **RecordPrompt::MAPPINGS,
#   **TaskPrompt::MAPPINGS,
#   **LedgerPrompt::MAPPINGS,
# }

PROMPTS = [RecordPrompt]

def get_prompt(prompt)
  PROMPTS.find { |p| prompt.match(p.REGEXP) }
end

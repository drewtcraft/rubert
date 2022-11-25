require_relative './command'
require_relative './record'
require_relative './task'

PROMPTS = {
  **GeneralPrompt::MAPPINGS,
  **CommandPrompt::MAPPINGS,
  **RecordPrompt::MAPPINGS,
  **TaskPrompt::MAPPINGS,
}

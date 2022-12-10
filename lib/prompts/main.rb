require_relative 'record'
require_relative 'ledger'
require_relative 'task'
require_relative 'config'

PROMPTS = [RecordPrompt, TaskPrompt, LedgerPrompt, HistoryPrompt, HelpPrompt, ExitPrompt, ConfigPrompt].freeze

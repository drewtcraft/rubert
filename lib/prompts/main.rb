require_relative 'record'
require_relative 'ledger'
require_relative 'task'

PROMPTS = [RecordPrompt, TaskPrompt, LedgerPrompt, HistoryPrompt, HelpPrompt, ExitPrompt].freeze

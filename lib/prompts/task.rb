require_relative './base'
require_relative '../models/Task'

module TaskPrompt
  class New < Prompt
    TITLE = "TASK NEW"
    def self.next_prompt_type(ledger, state)
      super
      puts 'hello'
      :command
    end
  end

  class List < Prompt
    TITLE = "TASK LIST"
    def self.next_prompt_type(ledger, state)
      super
      :command
    end
  end

  class Edit < Prompt
    TITLE = "TASK EDIT"
    def self.next_prompt_type(ledger, state)
      super
      :command
    end
  end

  class Done < Prompt
    TITLE = "TASK DONE"
    def self.next_prompt_type(ledger, state)
      super
      :command
    end
  end

  class Delete < Prompt
    TITLE = "TASK DELETE"
    def self.next_prompt_type(ledger, state)
      super
      :command
    end
  end

  MAPPINGS = {
    task_new: New,
    task_list: List,
    task_edit: Edit,
    task_done: Done,
    task_del: Delete,
  }
end

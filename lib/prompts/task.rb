require_relative './base'
require_relative './utils'
require_relative '../models/Task'

module TaskPrompt
  class New < Prompt
    include GetBody
    include GetTags

    TITLE = "TASK NEW"

    def self.next_prompt_type(ledger, state)
      super
      body = get_body "enter new task:"
      tags = get_tags 
      priority = get_priority

      task = Task.new_from_parts(body, tags)
      ledger.append_record record

      Output.puts_new_record record

      :command
    end
    
    private

    def self.get_priority
      Output.
  end

  class List < Prompt
    TITLE = "TASK LIST"
    def self.next_prompt_type(ledger, state)
      super
      ledger.tasks
        .reverse
        .each_with_index
        .to_a
        .reverse
        .each{|r, i| Output.puts_list_record(r, i) }
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

require_relative './base'
require_relative './utils'
require_relative './record'
require_relative '../models/Task'

module TaskPrompt
  module GetPriority
    def get_priority
      Output.puts "enter a priority"
      if (priority = Input.gets) != ""
        priority.to_i
      end
    end
  end

  class New < Prompt
    TITLE = "TASK NEW"

    include RecordPrompt::GetBodyGetTags
    include GetPriority

    def process
      super
      body = get_body "enter new task:", false
      tags = get_tags 
      priority = get_priority
      priority ||= Task::DEFAULT_PRIORITY

      task = Task.new_from_parts(body, tags, priority)
      @state.ledger.save_new_record! task

      Output.puts_between_lines{Output.puts_new_task task}
    end
  end

  class Show < Prompt
    TITLE = 'TASK SHOW'
    include RecordPrompt::GetRecord

    def process
      super
      task = get_record Task

      if task
        Output.puts_dashes
        Output.puts_full_task task
        Output.puts_dashes
      else
        Output.error "missing task id \"task show <id|keyword>\"", :input_error
      end
    end
  end

  class Edit < Prompt
    TITLE = "TASK EDIT"
    include GetPriority
    include RecordPrompt::GetRecord

    def process
      super
      task = get_record Task
      unless task
        Output.error "could not find task"
        return
      end
      task.body = Input.editor_edits task.body
      task.priority = get_priority
      @state.ledger.save_existing_record! task
      @state.soft_reset!
    end

  end


  class List < RecordPrompt::List
    TITLE = "TASK LIST"
    def process
      super

      tasks = @state.ledger.records.select{|r| r.class == Task}
      tasks = filter_records tasks
      tasks = slice_records tasks
      @state.last_task_list = tasks.reverse
      tasks = index_records tasks

      Output.puts_between_lines do
        tasks.each{|r, i| Output.puts_list_record(r, i) }
      end

      @state.soft_reset!
    end

    def filter_records(tasks)
      extract_args_hash
      select_done_tasks = false

      tasks = tasks.sort_by{|r| r.priority}.reverse

      unless args_hash[:keyword_args].empty?
        keyword_args = args_hash[:keyword_args]
        if keyword_args.has_key? :priority
          if keyword_args[:priority] == 'desc'
            tasks = tasks.reverse
          end
        end
        if keyword_args.has_key? :done
          if keyword_args[:done]
            select_done_tasks = true
          end
        end
      end

      unless args_hash[:string_args].empty?
        string_args = args_hash[:string_args]
        if string_args.any? {|s| s == :done}
          select_done_tasks = true
        end
      end

      if select_done_tasks
        tasks = tasks.select{|t| t.done}
      else
        tasks = tasks.reject{|t| t.done}
      end

      super tasks
    end
  end

  class Done < Prompt
    TITLE = "TASK DONE"
    include RecordPrompt::GetRecord
    def process
      super
      task = get_record Task
      unless task
        Output.error "could not find task"
        return
      end
      task.done = !task.done
      Output.log "task complete"
      @state.ledger.save_existing_record! task
      @state.soft_reset!
    end
  end

  class Delete < Prompt
    TITLE = "TASK DELETE"
    def process
      super
      :command
    end
  end

  MAPPINGS = {
    task_new: New,
    task_list: List,
    task_edit: Edit,
    task_done: Done,
    task_delete: Delete,
  }
end

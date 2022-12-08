require_relative './base'
require_relative './utils'
require_relative './record'
require_relative '../models/Task'

class TaskPrompt < RecordPrompt
  def self.create(state, arguments)
    body = get_body "enter new task:", false
    tags = get_tags
    priority = get_priority
    priority ||= Task::DEFAULT_PRIORITY

    task = Task.new_from_parts(body, tags, priority)
    state.ledger.save_new_record! task

    Output.puts_between_lines{ Output.puts_new_task task }

  end

  def self.show(state, arguments)
    task = get_record(state, arguments, Task)

    if task
      Output.puts_dashes
      Output.puts_full_task task
      Output.puts_dashes
    else
      Output.error "missing task id \"task show <id|keyword>\"", :input_error
    end
  end

  def self.edit(state, arguments)
    task = get_record(state, arguments, Task)
    unless task
      Output.error "could not find task"
      return
    end
    task.body = Input.editor_edits task.body
    task.priority = get_priority
    state.ledger.save_existing_record! task
    state.soft_reset!
  end

  def self.list(state, arguments)
    tasks = state.ledger.tasks
    tasks = filter_tasks(tasks, arguments)
    tasks = slice_records tasks
    state.last_task_list = tasks.reverse
    tasks = index_records tasks

    Output.puts_between_lines do
      tasks.each{ |r, i| Output.puts_list_record(r, i) }
    end

    state.soft_reset!
  end

  def self.done(state, arguments)
    task = get_record(state, arguments, Task)
    unless task
      Output.error "could not find task"
      return
    end
    task.done = !task.done
    Output.log "task complete #{task.done}"
    state.ledger.save_existing_record! task
    state.soft_reset!
  end

  def self.delete(state, arguments)

  end

  def self.help(state, arguments)

  end

  private
  def get_priority
    Output.puts "enter a priority"
    if (priority = Input.gets) != ""
      priority.to_i
    end
  end

  def filter_tasks(tasks, arguments)
    tasks = tasks.sort_by(&:priority).reverse

    kwargs = arguments.kwargs

    tasks = tasks.reverse if kwargs.key?(:priority) && (kwargs[:priority] == 'desc')

    select_done_tasks = false

    select_done_tasks = true if kwargs.key?(:done) && kwargs[:done]

    select_done_tasks = true if arguments.string_args.any? { |s| s == :done }

    tasks = if select_done_tasks
              tasks.select(&:done)
            else
              tasks.reject(&:done)
            end

    filter_records(tasks, arguments)
  end
end

module TaskPromptOld
  module GetPriority
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

      Output.puts_between_lines{ Output.puts_new_task task }
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


  class List < Prompt
    TITLE = "TASK LIST"
    include RecordPrompt::FilterListRecords

    def process
      super
      tasks = @state.ledger.tasks
      tasks = filter_tasks tasks
      tasks = slice_records tasks
      @state.last_task_list = tasks.reverse
      tasks = index_records tasks

      Output.puts_between_lines do
        tasks.each{ |r, i| Output.puts_list_record(r, i) }
      end

      @state.soft_reset!
    end

    def filter_tasks(tasks)
      tasks = tasks.sort_by(&:priority).reverse

      kwargs = @state.arguments.kwargs

      tasks = tasks.reverse if kwargs.key?(:priority) && (kwargs[:priority] == 'desc')

      select_done_tasks = false

      select_done_tasks = true if kwargs.key?(:done) && kwargs[:done]

      select_done_tasks = true if @state.arguments.string_args.any? { |s| s == :done }

      tasks = if select_done_tasks
                tasks.select(&:done)
              else
                tasks.reject(&:done)
              end

      filter_records tasks
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
      Output.log "task complete #{task.done}"
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

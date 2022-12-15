require_relative './base'
require_relative './record'
require_relative '../models/Task'

class TaskPrompt < RecordPrompt
  REGEXP = /^t(?:ask)?/.freeze

  def self.create(state, arguments)
    body = get_body "enter new task:"
    tags = get_tags
    priority = get_priority
    priority ||= Task::DEFAULT_PRIORITY

    task = Task.new_from_parts(body, tags, priority)
    state.ledger.save_new_record! task

    Output.puts_between_lines{ Output.puts_new_task task }
  end

  def self.show(state, arguments)
    task = get_record(state, arguments, :task)

    if task
      Output.puts_dashes
      Output.puts_full_task task
      Output.puts_dashes
    else
      Output.error "missing task id \"task show <id|keyword>\"", :input_error
    end
  end

  def self.edit(state, arguments)
    task = get_record(state, arguments, :task)
    unless task
      Output.error "could not find task"
      return
    end

    field = arguments.string_args.first
    unless field
      # TODO "help" here
      Output.error "field required"
      return
    end
    case field
    when :body # TODO abstract this in recordprompt
      body = get_edited_body task
      task.update(body:)
    when :tags
      tags = get_edited_tags task
      task.update(tags:)
    when :proiority
      priority = get_edited_priority task
      task.update(priority:)
    else
      #TODO
      Output.error "bad input: body or tags"
    end
    state.ledger.save_existing_record! task
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
  end

  def self.done(state, arguments)
    task = get_record(state, arguments, :task)
    unless task
      Output.error "could not find task"
      return
    end
    task.done = !task.done
    Output.log "task complete #{task.done}"
    state.ledger.save_existing_record! task
  end

  def self.delete(state, arguments)
    record = get_record(state, arguments, :task)
    return unless record && confirmed?( "delete task?")
    state.ledger.delete_record! record.id
  end

  def self.help(state, arguments)

  end

  def self.duplicate(state, arguments)

  end

  private
  def self.get_edited_priority(task)
    Input.editor_edits("#{task.priority}").strip.to_i
  end

  def self.get_priority
    Output.puts "enter a priority"
    if (priority = Input.gets) != ""
      priority.to_i
    end
  end

  def self.filter_tasks(tasks, arguments)
    tasks = tasks.sort_by(&:priority)

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

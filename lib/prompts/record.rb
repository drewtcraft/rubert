require_relative './base'
require_relative './utils'
require_relative '../models/Record'

# TODO: record page count=10 desc
# ^ display 10 records, then (y/n) for next page

class RecordPrompt < Prompt
  REGEXP = /^rec(?:ord)?/.freeze
  
  def self.create(state, arguments)
    body = get_body "enter new record:"
    tags = get_tags

    record = Record.new_from_parts(body, tags)
    state.ledger.save_new_record! record

    Output.log "saved new record!"
    Output.puts_between_lines { Output.puts_new_record record }
  end

  def self.show(state, arguments)
    record = get_record(state, arguments)

    if record
      Output.puts_dashes
      Output.puts_full_record record
      Output.puts_dashes
    else
      Output.error "missing record id \"record show <id|keyword>\"", :input_error
    end
  end

  def self.edit(state, arguments)
    record = get_record(state, arguments)
    unless record
      return
    end
    field = arguments.string_args.first
    unless field
      # TODO "help" here
      Output.error "field required"
      return
    end
    case field
    when :body
      body = get_edited_body record
      record.update(body:)
    when :tags
      tags = get_edited_tags record
      record.update(tags:)
    else
      Output.error "bad input: body or tags"
    end
    state.ledger.save_existing_record! record
  end

  def self.list(state, arguments)
    records = state.ledger.records
    records = filter_records records, arguments
    records = slice_records records
    state.last_record_list = records.reverse
    records = index_records records

    Output.puts_between_lines do
      records.each{ |r, i| Output.puts_list_record r, i }
    end
  end

  def self.delete(state, arguments)
    record = get_record(state, arguments)

    return unless record && confirmed?( "delete record?")

    state.ledger.delete_record! record.id
  end

  def self.help(state, arguments)
    Output.puts 'Record help'
    Output.puts_newline
    Output.puts 'INVOCATION:'
    Output.puts_newline
    Output.pad_dashed 'rec, record'
    Output.puts_newline
    Output.puts 'COMMANDS:'
    Output.puts_newline
    Output.pad_dashed 'new, list, edit, show, del, help'
    Output.puts_newline
    Output.puts_newline
    Output.puts 'EXAMPLES:'
    Output.puts_newline
    Output.pad_dashed '"rec help list" - Print info about the "list" command.'
    Output.pad_dashed '"rec list tags=code" - Print list of records tagged "code".'
    Output.puts_newline
    Output.pad_dashed 'NEW'
    Output.puts_newline
    Output.pad_dashed 'Create new record for current ledger.', 2
    Output.puts_newline
    Output.pad_dashed 'EXAMPLES:', 2
    Output.pad_dashed '"rec new"', 3
    Output.pad_dashed '"record new"', 3
    Output.puts_newline
    Output.pad_dashed 'LIST'
    Output.puts_newline
    Output.pad_dashed 'Print a list of records from the current ledger.', 2
    Output.puts_newline
    Output.pad_dashed 'With no options, prints the 5 most recent records.', 2
    Output.pad_dashed 'An index is printed with each record which can be used', 2
    Output.pad_dashed 'to select it with other commands like "edit" and "del".', 2
    Output.puts_newline
    Output.pad_dashed 'OPTIONS:', 2
    Output.pad_dashed 'created=(asc|desc)', 3
    Output.pad_dashed 'updated=(asc|desc)', 3
    Output.pad_dashed 'first', 3
    Output.pad_dashed 'last', 3
    Output.pad_dashed 'tags=a,b,c', 3
    Output.puts_newline
    Output.pad_dashed 'EXAMPLES:', 2
    Output.pad_dashed '"rec list"', 3
    Output.pad_dashed '"rec list created=desc" -- get oldest 5 records', 3
    Output.pad_dashed '"rec list last" -- get oldest record', 3
    Output.pad_dashed '"rec list tags=code,school" -- get all records tagged code and school', 3
    Output.puts_newline
  end

  def self.pin(state, arguments)
    record = get_record(state, arguments)
    state.ledger.pin_record()
  end

  protected

  def self.get_edited_body(record)
    Input.editor_edits record.body
  end

  def self.get_edited_tags(record)
    str_tags = Input.editor_edits record.tags.join(', ')
    parse_string_tags tags
  end

  def self.get_body(msg)
    Output.puts msg
    Input.gets
  end

  def self.parse_string_tags(str_tags)
    str_tags.split(',')
        .map(&:strip)
        .reject { |t| t == '' }
  end

  def self.get_tags
    Output.puts "enter comma-separated tags:"
    tags = Input.gets
    parse_string_tags tags
  end

  def self.get_record(state, arguments, t = :record)
    record = if arguments.int_args.any?
               index = arguments.int_args.first
               Output.log "looking for #{t} with index: #{index}"
               t == :record ? state.last_record_list[index] : state.last_task_list[index]
             end

    if record
      Output.log "#{t} found!" if record
    else
      Output.error "could not find record"
    end

    record
  end

  def self.filter_records(records, arguments)
    kwargs = arguments.kwargs
    if kwargs.key? :created
      records = records.sort_by(&:created_at)
      records = records.reverse if kwargs[:created] == 'desc'
    elsif kwargs.key? :updated
      records = records.sort_by(&:updated_at)
      records = records.reverse if kwargs[:updated] == 'desc'
    end

    if kwargs.key? :tags
      tags = kwargs[:tags]
      records = records.select { |r| (r.tags) }
    end

    if kwargs.key? :first
      records = records.take(kwargs[:first].to_i)
    elsif kwargs.key? :last
      records = records.last((kwargs[:last].to_i * -1))
    end

    string_args = arguments.string_args
    if string_args.any? { |s| s == :first }
      records = records.take(10)
    elsif string_args.any? { |s| s == :last }
      records = records.last(10)
    end

    records
  end

  def self.index_records(records)
    records.reverse.each_with_index.to_a.reverse
  end

  def self.slice_records(records)
    records.length > 10 ? records[-11..] : records
  end
end
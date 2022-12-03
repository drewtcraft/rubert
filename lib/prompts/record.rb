require_relative './base'
require_relative './utils'
require_relative '../models/Record'

module RecordPrompt
  module GetBodyGetTags
    def get_body(msg, multi = true)
      Output.puts msg
      if multi
        Input.multiline_gets
      else
        Input.gets
      end
    end

    def get_tags
      Output.puts "enter comma-separated tags:"
      tags = Input.one_line_gets
      tags.split(',')
          .map {|t| t.strip}
          .select {|t| t != ''}
    end
  end

  class New < Prompt
    TITLE = 'NEW RECORD'
    include GetBodyGetTags

    def process
      super

      body = get_body "enter new record:"
      tags = get_tags

      record = Record.new_from_parts(body, tags)
      @state.ledger.save_new_record! record

      Output.log "saved new record!"
      Output.puts_between_lines { Output.puts_new_record record }
    end
  end

  module GetRecord
    def get_record(t = Record)
      # TODO this whole method sucks
      is_record = t == Record

      record = if @args_hash[:int_args].any?
                 index = @args_hash[:int_args].first
                 Output.log "looking for #{t} with index: #{index}"
                 # TODO if @state.has_last_record_list
                 is_record ? @state.last_record_list[index] : @state.last_task_list[index]
               elsif @args_hash[:string_args].any?
                 id = @args_hash[:string_args].first
                 records = is_record ? @state.ledger.records : @state.ledger.tasks
                 if id.match(/first/)
                   records.first
                 elsif id.match(/last/)
                   records.last
                 end
                 Output.log "looking for #{t} with ID: #{id}"
                 records.find{|r| r.id == id}
               end

      Output.log "#{t} found!" if record

      record
    end
  end

  class Show < Prompt
    TITLE = 'RECORD SHOW'
    include GetRecord
    def process
      super
      record = get_record

      if record
        Output.puts_dashes
        Output.puts_full_record record
        Output.puts_dashes
      else
        Output.error "missing record id \"record show <id|keyword>\"", :input_error
      end
    end
  end


  class Edit < Prompt
    TITLE = 'RECORD EDIT'
    include GetRecord
    def process
      super

      record = get_record
      unless record
        Output.error "could not find record"
        return
      end
      record.body = Input.editor_edits record.body
      @state.ledger.save_existing_record! record
      @state.soft_reset!
    end

    private
  end

  class List < Prompt
    TITLE = 'RECORD LIST'
    def process
      super
      records = @state.ledger.records.select{|r| r.is_a? Record and not r.is_a? Task}
      records = filter_records records
      records = slice_records records
      @state.last_record_list = records.reverse
      records = index_records records

      Output.puts_between_lines do
        records.each{|r, i| Output.puts_list_record(r, i) }
      end

      @state.soft_reset!
    end

    def index_records(records)
      records.reverse.each_with_index.to_a.reverse
    end

    def slice_records(records)
      records.length > 10 ? records[-11..-1] : records
    end

    def filter_records(records)
      # handles sorting by created/updated/tags
      unless @args_hash[:keyword_args].empty?
        keyword_args = @args_hash[:keyword_args]
        if keyword_args.has_key? :created
          records = records.sort_by{|r| r.created_at}
          if keyword_args[:created] == 'desc'
            records = records.reverse
          end
        elsif keyword_args.has_key? :updated
          records = records.sort_by{|r| r.updated_at}
          if keyword_args[:updated] == 'desc'
            records = records.reverse
          end
        end

        if keyword_args.has_key? :tags
          tags = keyword_args[:tags]
          records = records.select{|r| (r.tags & tags).length == tags.length}
        end

        if keyword_args.has_key? :first
          records = records[0..keyword_args[:first].to_i]
        elsif keyword_args.has_key? :last
          records = records[((keyword_args[:last].to_i) * -1)..-1]
        end
      end

      # handles first/last stuff
      unless @args_hash[:string_args].empty?
        string_args = @args_hash[:string_args]
        if string_args.any? {|s| s == :first}
          records = records[0..10]
        elsif string_args.any? {|s| s == :last}
          records = records[-11..-1]
        end
      end

      records
    end
  end

  class Delete < Prompt
    TITLE = "DELETE RECORD"
    include GetRecord
    def process
      super

      record = get_record

      return unless record and confirmed? "delete record?"

      @state.ledger.delete_record! record.id
    end
  end

  MAPPINGS = {
    record_new: New,
    record_list: List,
    record_show: Show,
    record_edit: Edit,
    record_delete: Delete,
  }
end

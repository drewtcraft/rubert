require_relative './base'
require_relative './utils'
require_relative '../models/Record'

module RecordPrompt
  class New < Prompt
    include GetBody
    include GetTags

    TITLE = 'NEW RECORD'

    def self.next_prompt_type(ledger, state)
      super

      body = get_body "enter new record:"
      tags = get_tags

      record = Record.new_from_parts(body, tags)
      ledger.append_record record

      Output.puts_new_record record

      :command
    end
  end

  class Show < Prompt
    TITLE = 'RECORD SHOW'
    def self.next_prompt_type(ledger, state)
      super
      tmp_id = state.args.first.to_i
      record = ledger.records[tmp_id]
      Output.puts_full_record record
      :command
    end
  end


  class Edit < Prompt
    TITLE = 'RECORD EDIT'
    def self.next_prompt_type(ledger, state)
      unless state.has_args?
        Output.puts "missing record index"
        return :command
      end
      unless state.has_last_record_list?
        Output.puts "run 'record list' to populate record indexes"
        return :command
      end

      super
      tmp_id = state.args.first.to_i
      record = state.last_record_list[tmp_id]
      record.body = Input.editor_edits record.body
      ledger.save_existing_record record
      :command
    end
  end

  class List < Prompt
    TITLE = 'RECORD LIST'
    def self.next_prompt_type(ledger, state)
      super
      records_to_list = ledger.records
      # process filter here, tap????
      # possible filter values
      # - created
      # - updated
      # - tagged
      #
      records_to_list = ledger.records
        .reverse
        .each_with_index
        .to_a
        .reverse

      state.last_record_list = records_to_list
      records_to_list.each{|r, i| Output.puts_list_record(r, i) }

      :command
    end
  end

  class Delete < Prompt
    def self.next_prompt_type(ledger, state)
      super
      # TODO
      :command
    end
  end

  MAPPINGS = {
    record_new: New,
    record_list: List,
    record_show: Show,
    record_edit: Edit,
    record_del: Delete,
  }
end

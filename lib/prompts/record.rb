require_relative './base'
require_relative '../models/Record'

module RecordPrompt
  class New < Prompt
    TITLE = 'NEW RECORD'
    def self.next_prompt_type(ledger, state)
      super

      body = get_body
      tags = get_tags

      record = Record.new_from_parts(body, tags)
      ledger.append_record record

      Printer.puts_new_record record

      :command
    end

    private

    def self.get_body
      puts "enter new record (return twice to finish writing):"
      Input.multiline_gets
    end

    def self.get_tags
      puts 'enter comma-separated tags (e.g. "code, 2142, ..."):'
      tags = Input.one_line_gets
      tags.split(',')
        .map {|t| t.strip}
        .select {|t| t != ''}
    end
  end

  class Show < Prompt
    TITLE = 'RECORD SHOW'
    def self.next_prompt_type(ledger, state)
      super
      tmp_id = state[:args].first.to_i
      record = ledger.records[tmp_id]
      Printer.puts_full_record record
      :command
    end
  end


  class Edit < Prompt
    TITLE = 'RECORD EDIT'
    def self.next_prompt_type(ledger, state)
      super
      tmp_id = state[:args].first.to_i
      record = ledger.records[tmp_id]
      new_body = Input.editor_edits record.body
      ledger.records[tmp_id].update(body:new_body)
      :command
    end
  end

  class List < Prompt
    TITLE = 'RECORD LIST'
    def self.next_prompt_type(ledger, state)
      super
      ledger.records
        .reverse
        .each_with_index
        .to_a
        .reverse
        .each{|r, i| Printer.puts_list_record(r, i) }

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

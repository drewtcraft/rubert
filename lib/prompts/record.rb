require_relative './base'

class NewRecordPrompt < Prompt
  def get_next_prompt
    Printer.clear
    Printer.puts_prompt_title 'NEW RECORD'

    body = get_body
    tags = get_tags

    record = Record.new_from_parts(body, tags)
    @ledger.add_record record

    Printer.clear
    Printer.puts_new_record record

    CommandPrompt
  end

  private

  def get_body
    puts "enter new record (return twice to finish writing):"
    body = multiline_gets
    if body == ""
      multiline_gets
    end
    body
  end

  def get_tags
    puts 'enter comma-separated tags (e.g. "code, 2142, ..."):'
    tags = gets
    tags = tags.split(',')
      .map {|t| t.strip}
      .select {|t| t != ''}
    tags
  end
end

class EditRecordPrompt < Prompt
  DEFAULT_INPUT_TYPE = InputTypes::EDITOR
  def get_next_prompt
  end
end

class ListRecordPrompt < Prompt
  # load working file (into memory??)

end

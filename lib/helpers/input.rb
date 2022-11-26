alias standard_gets gets

module Input
  TEMP_FILE_NAME = 'temp_record_file.txt'

  private_constant :TEMP_FILE_NAME

  def self.gets
    standard_gets.chomp
  end

  def self.one_line_gets
    # almost just an alias for gets but can also open the EDITOR
    if (text = gets) == "editor"
      editor_gets
    end
    text
  end

  def self.multiline_gets
    # TODO this is broken after adding chomp to gets

    # like "gets", but concats all content entered until a blank newline
    # can open vim as well

    all_text = ""
    used_editor = false
    while (text = standard_gets) != "\n"
      if text == "editor\n"
        used_editor = true
        all_text = editor_gets
        break
      else
        all_text << text
      end
    end
    used_editor ? all_text : all_text[0..all_text.length - 2];
  end

  def self.editor_gets
    system("nvim", TEMP_FILE_NAME)
    if File.exist?(TEMP_FILE_NAME)
      input = File.read(TEMP_FILE_NAME)
      File.delete(TEMP_FILE_NAME) 
      input
    else
      ''
    end
  end

  def self.editor_edits(text)
    File.open(TEMP_FILE_NAME, 'w') do |h| 
      h.write text
    end
    system("nvim", TEMP_FILE_NAME)
    input = File.read(TEMP_FILE_NAME)
    File.delete(TEMP_FILE_NAME) 
    input
  end
end

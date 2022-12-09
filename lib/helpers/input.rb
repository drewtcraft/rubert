alias standard_gets gets

module Input
  TEMP_FILE_NAME = 'temp_record_file.txt'

  private_constant :TEMP_FILE_NAME

  def self.gets
    if (text = standard_gets) == 'editor'
      editor_gets
    end
    text.chomp
  end

  def self.editor_gets
    system('nvim', TEMP_FILE_NAME)
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
    system('nvim', TEMP_FILE_NAME)
    input = File.read(TEMP_FILE_NAME)
    File.delete(TEMP_FILE_NAME) 
    input
  end
end

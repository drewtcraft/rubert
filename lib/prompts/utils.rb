module InputTypes
  ONE_LINE = 0
  MULTILINE = 1
  EDITOR = 3
end

TEMP_FILE_NAME = 'temp_record_file.txt'
def editor_gets
  # launches the user's EDITOR and retrieves content
  puts 'fuck'
  system("nvim", TEMP_FILE_NAME)
  if File.exist?(TEMP_FILE_NAME)
    input = File.read(TEMP_FILE_NAME)
    File.delete(TEMP_FILE_NAME) 
    input
  else
    ''
  end
end

def multiline_gets
  # like "gets", but concats all content 
  # entered until a blank newline

  all_text = ""
  while (text = gets) != "\n"
    if text == "editor\n"
      all_text = editor_gets
      break
    else
      all_text << text
    end
  end
  all_text
end

def one_line_gets
  if (text = gets) == "editor\n"
    editor_gets
  end
  text
end

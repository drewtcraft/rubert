require_relative 'utils'

class Prompt
  DEFAULT_INPUT_TYPE = InputTypes::ONE_LINE
  def initialize(state)
    @state = state
  end

  def get_input
    case self.class::DEFAULT_INPUT_TYPE
    when InputTypes::EDITOR
      editor_gets
    when InputTypes::MULTILINE
      multiline_gets
    when InputTypes::ONE_LINE
      gets
    end
  end

  def get_next_prompt
    raise 'not implemented'
  end
end

class TagRecordPrompt < Prompt
  def get_next_prompt
    puts "enter tags"
    input = get_input
    puts state[:record]
    puts "record added with tags: #{input}"
    CommandPrompt
  end
end

class NewRecordPrompt < Prompt
  DEFAULT_INPUT_TYPE = InputTypes::MULTILINE

  def get_next_prompt
    puts "enter new record"
    @state[:record] = get_input
    puts @state[:record]
    TagRecordPrompt
  end
end

class EditRecordPrompt < Prompt
  DEFAULT_INPUT_TYPE = InputTypes::EDITOR
  def get_next_prompt
    system("#{ENV['EDITOR']} temp_edit_file.txt")
    # gets content of file
    # deletes temp file
    # writes content to ledger
  end
end

class NewSpacePrompt < Prompt
  def get_next_prompt
    puts "enter space name"
    # create and switch to space
    CommandPrompt
  end
end

module CommandRegExp
  EXIT = /^\s?exit/i
  QUIT = /^\s?quit/i
  RECORD_NEW = /^\s?rec[ord]?\s?new/i
  SPACE_NEW = /^\s?sp[ace]?\s?new/i
  HELP = /^\s?help/i
end

class CommandPrompt < Prompt
  def get_next_prompt
    puts "enter COMMAND (\"help\" for list of commands):"
    input = get_input
    put_newline
    put_newline

    case input
    when CommandRegExp::EXIT, CommandRegExp::QUIT
      exit 0
    when CommandRegExp::RECORD_NEW
      NewRecordPrompt
    when CommandRegExp::HELP
      puts '"add( )rec[ord]", "exit", "quit"'
      self.class
    else
      puts "#{input} is not a command, try typing \"help\""
      self.class
    end
  end
end

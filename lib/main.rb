# states:
# command
# create record-space, becomes default
# switch record-space
# list record-space
# record (to main)
# tag record (to main)
# list
# list by tag
# list by query

class Putter
  #singleton
#  def put(str, indent=
end

def put_break(l=20)
  puts '-' * l
end

def put_newline
  puts "\n"
end

def multiline_gets
  # like "gets", but concats all content 
  # entered until a blank newline

  all_text = ""
  while (text = gets) != "\n"
    all_text << text
  end
  all_text
end

class State
  MULTILINE = false
  def get_input
    if self.class::MULTILINE
      multiline_gets
    else
      gets
    end
  end

  def get_next_state;raise 'not implemented';end
end

class TagRecordState < State
  def initialize(record_str, record_id=nil)
    @record = record_str
  end
  def get_next_state
    puts "enter tags"
    input = get_input
    puts @record
    puts "record added with tags: #{input}"
    CommandState.new
  end
end

class NewRecordState < State
  MULTILINE = true

  def get_next_state
    puts "enter new record"
    input = get_input
    TagRecordState.new input
  end
end

module CommandRegExp
  EXIT = /^\s?exit/i
  QUIT = /^\s?quit/i
  ADD_RECORD = /^\s?add?\s?rec[ord]?/i
  HELP = /^\s?help/i
end

class CommandState < State
  def get_next_state
    puts "enter COMMAND (\"help\" for list of commands):"
    input = get_input
    put_newline
    put_newline

    case input
    when CommandRegExp::EXIT, CommandRegExp::QUIT
      exit 0
    when CommandRegExp::ADD_RECORD
      NewRecordState.new
    when CommandRegExp::HELP
      puts '"add( )rec[ord]", "exit", "quit"'
      itself
    else
      puts "#{input} is not a command, try typing \"help\""
      itself
    end
  end
end

state = CommandState.new
loop do
  state = state.get_next_state()
  put_newline
  put_break
end


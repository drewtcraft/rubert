class Arguments
  # parses user input into a nicer abstraction

  attr_reader :prompt, :command, :kwargs, :int_args, :string_args

  def initialize(arg_string)
    # arg_string comes in the form of:
    # <prompt-type> <command> <extra-arguments...>
    # ex. task list created=desc done
    @arg_string = arg_string
    @prompt = nil
    @command = nil
    @kwargs = {}
    @int_args = []
    @string_args = []

    extract_args! arg_string
  end

  def to_s
    "Arguments: #{@arg_string}"
  end

  def parse_command(command)
    case command
    when CommandRegExp::NEW
      :create
    when CommandRegExp::SHOW
      :show
    when CommandRegExp::LIST
      :list
    when CommandRegExp::EDIT
      :edit
    when CommandRegExp::DELETE
      :delete
    when CommandRegExp::SWITCH
      :switch
    when CommandRegExp::DONE
      :done
    when CommandRegExp::HELP
      :help
    else
      :show
    end
  end

  def extract_args!(arg_string)
    split_string = arg_string.split(' ').compact
    @prompt, command_str = split_string[0..2]
    @command = parse_command command_str

    split_string.drop(2).each do |argument|
      case argument
      when /\S=/
        key, value = argument.split('=')
        @kwargs[key.to_sym] = value
      when /^\d+$/
        @int_args << argument.to_i
      else
        @string_args << argument.to_sym
      end
    end
  end
end
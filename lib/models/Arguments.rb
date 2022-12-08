class Arguments
  # parses user input into a nicer abstraction

  attr_reader :prompt, :command, :kwargs, :int_args, :string_args

  def initialize(arg_string)
    # arg_string comes in the form of:
    # <prompt-type> <command> <extra-arguments...>
    # ex. task list created=desc done

    @prompt = nil
    @command = nil
    @kwargs = {}
    @int_args = []
    @string_args = []

    extract_args! arg_string
  end

  def extract_args!(arg_string)
    split_string = arg_string.split(' ').compact
    @prompt, @command = split_string[0..2]

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
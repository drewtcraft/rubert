require_relative '../helpers/output'

class Prompt
  TITLE = nil
  NEXT_PROMPT_TYPE = :command

  def initialize(state)
    @state = state
    @next_prompt_type = self::class::NEXT_PROMPT_TYPE
    @args_hash = extract_args_hash
  end

  def process
    puts_title
  end

  def puts_title
    if self::class::TITLE
      Output.puts_prompt_title self::class::TITLE
    end
  end

  def confirmed?(msg)
    Output.puts "#{msg} (y/n)"
    Input.gets == "y"
  end

  def next_prompt_type
    @next_prompt_type
  end

  private

  def extract_args_hash
    # remove first two words, the rest are arguments (<domain> <command> <argument>)
    base_hash = {keyword_args: {}, int_args: [], string_args: []}

    unless @state.has_arg_string?
      return base_hash
    end

    @state.arg_string.split(' ').reverse[0..-3].inject(base_hash) do |hash, argument|
      if argument.match(/[^\s]=/)
        key, value = argument.split('=')
        hash[:keyword_args][key.to_sym] = value
      elsif argument.match(/^\d+$/)
        hash[:int_args] << argument.to_i
      else
        hash[:string_args] << argument.to_sym
      end
      hash
    end
  end
end

module GeneralPrompt
  class ExitPrompt < Prompt
    TITLE = "EXITING"
    def process
      super
      exit 0
    end
  end

  class HelpPrompt < Prompt
    TITLE = "HELP"
    def process
      super
      Output.log "available commands"
      Output.puts_dashes
      Output.puts "[exit|quit]"
      Output.puts "his(tory)"
      Output.puts "rec(ord)".ljust(10) + "[new|list|show|edit|del|help]"
      Output.puts "t(ask)".ljust(10) + "[new|list|done|show|edit|del|help]"
      Output.puts "le(dger)".ljust(10) + "[new|list|switch|show|del|help]"
      Output.puts_dashes
    end
  end

  class HistoryPrompt < Prompt
    TITLE = "HISTORY"
    def process
      super
      Output.log "last 10"
      Output.puts_dashes
      @state.last_commands.each {|cmd| Output.puts cmd}
      Output.puts_dashes
    end
  end

  MAPPINGS = {
    exit: ExitPrompt,
    quit: ExitPrompt,
    history: HistoryPrompt,
    help: HelpPrompt,

  }
end

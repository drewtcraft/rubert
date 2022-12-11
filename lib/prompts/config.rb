require_relative 'base'
require_relative '../models/Config'

class ConfigPrompt < Prompt
  REGEXP = /^conf(?:ig)$/

  def self.ensure(state, arguments)
    config = if Config.file_exists?
               Output.log "loading config"
               Config.from_file
             else
               create_new_config
             end
    state.config = config
  end

  private
  def self.create_new_config
    Output.log 'config.yml not found'
    Output.log 'creating config.yml'

    Output.puts_underlined 'SETUP'
    Output.puts 'enter the default path to store files, or leave blank to store in repo'
    base_directory = Input.gets.strip
    base_directory = '../rubert-ledgers/' if base_directory == ''
    unless File.exist? base_directory
      # TODO inject README into directory
      # git init
      Dir.mkdir base_directory
    end

    Output.puts 'enter a ledger name (e.g. "JOURNAL")'
    last_ledger_name = Input.gets.strip

    config = Config.new(last_ledger_name:, base_directory:)
    config.write!
    config
  end
end
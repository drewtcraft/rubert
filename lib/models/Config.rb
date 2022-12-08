require_relative 'base'
require 'yaml'

class Config
  # eventual destination for user settings
  CONFIG_FILE_NAME = 'config'
  DEFAULT_BASE_DIRECTORY = '../rubert-files'

  attr_accessor :base_directory, :last_ledger_name

  include Writable

  def initialize(params={})
    @file_name = CONFIG_FILE_NAME
    @base_directory = params[:base_directory]
    @last_ledger_name = params[:last_ledger_name]
  end

  def self.from_file
    new(YAML.load_file("#{CONFIG_FILE_NAME}.yml"))
  end

  def self.file_exists?
    File.exist? "#{CONFIG_FILE_NAME}.yml"
  end

  def to_hash
    {
      base_directory: @base_directory,
      last_ledger_name: @last_ledger_name,
    }
  end
end
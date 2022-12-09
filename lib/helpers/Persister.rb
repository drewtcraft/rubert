require 'singleton'

module Persistence
  CONFIG_FILE_NAME = 'config'

  def self.load_config
    load CONFIG_FILE_NAME
  end

  def self.write_config!(hash)
    write!(CONFIG_FILE_NAME, hash)
  end

  def self.config_exists?
    exist? CONFIG_FILE_NAME
  end

  def self.load_ledger(ledger_name)
    load(ledger_name, {permitted_classes: [Symbol, Time], aliases: true})
  end

  def self.write_ledger!(hash, ledger_name)
    write!(ledger_name, hash)
  end

  def self.ledger_exists?(ledger_name)
    exist? ledger_name
  end

  private

  def ensure_extension(name)
    unless name.match(/\.yml$/)
      "#{name}.yml"
    end
    name
  end

  def load(file_name, kwargs = {})
    file_name = ensure_extension file_name
    YAML.load_file(file_name, **kwargs)
  end

  def write!(file_name, hash)
    file_name = ensure_extension file_name
    File.open(file_name, 'w') do |h|
      h.write hash.to_yaml
    end
  end

  def exist?(file_name)
    file_name = ensure_extension file_name
    File.exist? file_name
  end

end

require 'singleton'

module Persistence
  CONFIG_FILE_NAME = 'config'

  def self.backup_ledgers!(directory)
    command = "pushd #{directory}; "
    command << "git add . && git commit -m 'backup' && git push; "
    command << 'popd'
    system(command)
  end

  def self.load_config_if_exists
    load_config if config_exists?
  end

  def self.load_config
    load CONFIG_FILE_NAME
  end

  def self.write_config!(hash)
    write!(CONFIG_FILE_NAME, hash)
  end

  def self.config_exists?
    exist? CONFIG_FILE_NAME
  end

  def self.load_ledger(ledger_name, directory)
    file_name = smash_paths(directory, ledger_name)
    load(file_name, {permitted_classes: [Symbol, Time], aliases: true})
  end

  def self.write_ledger!(hash, ledger_name, directory)
    file_name = smash_paths(directory, ledger_name)
    write!(file_name, hash)
  end

  def self.ledger_exists?(ledger_name, directory)
    file_name = smash_paths(directory, ledger_name)
    exist? file_name
  end

  def self.delete_ledger!(ledger_name, directory)
    file_name = "#{directory}/#{ledger_name}".sub(%r{//}, '/')
    delete! file_name
  end

  private

  def self.smash_paths(*args)
    args.join('/').sub(%r{//}, '/')
  end

  def self.ensure_extension(name)
    name = "#{name}.yml" if name.length <= 4 || name[-3..-1] != "yml"
    name
  end

  def self.load(file_name, kwargs = {})
    file_name = ensure_extension file_name
    YAML.load_file(file_name, **kwargs)
  end

  def self.write!(file_name, hash)
    file_name = ensure_extension file_name
    File.open(file_name, 'w') do |h|
      h.write hash.to_yaml
    end
  end

  def self.exist?(file_name)
    file_name = ensure_extension file_name
    File.exist? file_name
  end

  def self.delete!(file_name)
    file_name = ensure_extension file_name
    File.delete(file_name)
  end
end

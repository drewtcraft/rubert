require 'securerandom'
require_relative './base'
require_relative 'Task'
require_relative 'Record'
require_relative '../helpers/output'

class Ledger < Timestamped
  attr_reader :name, :created_at, :updated_at

  def initialize(params)
    super params
    @name = params[:name]
    @directory = params[:directory]
    @file_name = @name
    @records = params[:records].map do |r|
      if r.has_key? :priority
        Task.new r
      else
        Record.new r
      end
    end
  end

  def self.new_from_name(name, directory)
    created_at = updated_at = Time.now
    Ledger.new({
      name:,
      directory:,
      records: [], 
      created_at:,
      updated_at:,
    })
  end

  def self.file_exists?(name, directory)
    Persistence.ledger_exists?(name, directory)
  end

  def self.from_file(name, directory)
    l = Persistence.load_ledger(name, directory)
    Ledger.new l
  end

  def write!
    Persistence.write_ledger!(to_hash, @name, @directory)
  end

  def records
    @records.select{ |r| r.is_a? Record and not r.is_a? Task }
  end

  def tasks
    @records.select{ |r| r.class == Task }
  end

  def to_hash
    {
      name: @name,
      records: @records.map{|r| r.to_hash},
      created_at: @created_at,
      updated_at: @updated_at,
    }
  end

  def save_new_record!(record)
    @records << record
    write!
  end

  def save_existing_record!(record)
    @records = @records.map{|r| r.id == record.id ? record : r}
    write!
  end

  def delete_record!(record_id)
    @records = @records.select{|r| r.id == record_id}
    write!
  end
end

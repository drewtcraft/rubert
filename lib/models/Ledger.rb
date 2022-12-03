require 'securerandom'
require_relative './base'
require_relative '../helpers/output'

class Ledger < Timestamped
  attr_reader :name, :records, :created_at, :updated_at

  def initialize(params)
    super params
    @name = params[:name]
    @records = params[:records].map do |r|
      if r.has_key? :priority
        Task.new r
      else
        Record.new r
      end
    end
  end

  def self.from_name(name)
    created_at = updated_at = Time.now
    Ledger.new({
      name:, 
      records: [], 
      created_at:,
      updated_at:,
    })
  end

  def self.from_file(name)
    l = YAML.load_file("#{name}.yml", permitted_classes: [Symbol, Time], aliases: true)
    Ledger.new l
  end

  def to_hash
    {
      name: @name,
      records: @records.map{|r| r.to_hash},
      created_at: @created_at,
      updated_at: @updated_at,
    }
  end

  def write!
    File.open("#{@name}.yml", 'w') do |h| 
      h.write self.to_hash.to_yaml
    end
  end

  def save_new_record!(record)
    @records << record
    write!
  end

  def save_existing_record!(record)
    @records = @records.map{|r| r.id === record.id ? record : r}
    write!
  end

  def delete_record!(record_id)
    @records = @records.select{|r| r.id === record_id}
    write!
  end
end

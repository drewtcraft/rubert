require 'securerandom'
require_relative './base'
require_relative '../helpers/output'

class Ledger < Timestamped
  attr_reader :name, :records, :tasks, :created_at, :updated_at

  def initialize(params)
    super params
    @name = params[:name]
    @records = params[:records].map{|r| Record.new r}
    @tasks = params[:tasks].map{|t| Task.new t}
  end

  def self.from_name(name)
    created_at = updated_at = Time.now
    Ledger.new({
      name:, 
      records: [], 
      tasks: [], 
      created_at:,
      updated_at:,
    })
  end

  def self.from_file(name)
    l = YAML.load_file("#{name}.yml", permitted_classes: [Symbol, Time])
    Ledger.new l
  end

  def to_hash
    {
      name: @name,
      records: @records.map{|r| r.to_hash},
      tasks: @tasks.map{|t| t.to_hash},
      created_at: @created_at,
      updated_at: @updated_at,
    }
  end

  def write
    File.open("#{@name}.yml", 'w') do |h| 
      h.write self.to_hash.to_yaml
    end
  end

  def save_new_record(record)
    Printer.puts_new_record record
    @records << record
    write
  end

  def save_existing_record(record)
    @records = @records.map{|r| r.id === record.id ? record : r}
    write
  end

  def list_records(filter)
    records = @records.clone
    @records.each do |r|
      Printer.puts_list_record r
    end
  end

  def edit_record(record)
  end

  def append_task(task)
    @tasks << task
    write
  end
end

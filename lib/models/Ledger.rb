require 'securerandom'
require_relative '../helpers/printer'

class Ledger
  attr_reader :id, :name, :records, :tasks, :created_at

  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @records = params[:records].map{|r| Record.new r}
    @tasks = params[:tasks].map{|t| Task.new t}
    @created_at = params[:created_at]
  end

  def self.from_name(name)
    Ledger.new({
      id: SecureRandom.uuid,
      name:, 
      records: [], 
      tasks: [], 
      created_at: Time.now,
    })
  end

  def self.from_file(name)
    l = YAML.load_file("#{name}.yml")
    self.class.new l
  end

  def write
    File.open("#{@name}.yml", 'w') do |h| 
      h.write self.instance_eval().to_yaml
    end
  end

  def append_record(record)
    Printer.puts_new_record record
    @records << record
    write
  end

  def list_records(filter)
    @records.each do |r|
      Printer.puts_list_record r
    end
  end

  def edit_record(record_id)
  end

  def append_task(task)
    @tasks << task
    write
  end

  def list_tasks(format)
    @tasks.each do |t|
      Printer.puts_list_task t
    end
  end
end

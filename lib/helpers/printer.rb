alias standard_puts puts

module Printer
  INDENT_LEVEL = 2
  LIST_RECORD_TRUNCATE = 60
  TIME_DATE_FORMAT = '%m/%d/%Y %I:%M%p'

  private_constant :INDENT_LEVEL, :LIST_RECORD_TRUNCATE, :TIME_DATE_FORMAT

  def self.puts(s)
    standard_puts s
  end

  def self.puts_dashes(l=20)
    puts '-' * l
  end

  def self.puts_newline
    puts "\n"
  end

  def self.puts_in_box(s)
    puts '_' * (s.length + 6)
    puts "|  #{s}  |"
    puts '=' * (s.length + 6)
  end

  def self.puts_underlined(s)
    puts s
    puts_dashes s.length
  end

  def self.puts_indented(s, indent=1)
    puts '-' * (indent * INDENT_LEVEL) + "> #{s}" 
  end

  def self.clear
    system('clear')
  end

  def self.log(*args)
    args.each{ |it| puts_indented it }
  end

  def self.puts_new_record(r)
    puts_indented 'RECORD ADDED'
    puts_dashes
    puts r.body
    puts "tags: #{r.tags}"
    puts r.created_at
    puts_dashes
  end

  def self.puts_new_task(t)
    puts_indented 'TASK ADDED'
    puts_dashes
    puts t.body
    puts t.created_at
    puts_dashes
  end

  def self.puts_prompt_title(t)
    puts_dashes
    puts t
  end

  def self.puts_list_record(r, i)
    if r.body.length > 60
      puts "[#{i}] #{r.body[0..60]}... #{r.created_at.strftime(TIME_DATE_FORMAT)}"
    else
      puts "[#{i}] #{r.body} #{r.created_at.strftime('%m/%d/%Y %I:%M%p')}"
    end
  end

  def self.puts_full_record(r)
    puts r.body
    puts r.created_at
    puts "TAGGED: #{r.tags.join(', ')}"
  end
end

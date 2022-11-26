alias standard_puts puts

module Output
  INDENT_LEVEL = 2
  LIST_RECORD_TRUNCATE = 30
  TIME_DATE_FORMAT = '%m/%d/%y %I:%M%p'

  private_constant :INDENT_LEVEL, :LIST_RECORD_TRUNCATE, :TIME_DATE_FORMAT

  def self.puts(s)
    return unless s 
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
    puts t.priority
    puts t.created_at
    puts_dashes
  end

  def self.puts_prompt_title(t)
    puts_dashes
    puts t
  end

  def self.puts_list_record(r, i)
    body = if r.body[0..LIST_RECORD_TRUNCATE].match("\n")
      r.body[0..LIST_RECORD_TRUNCATE].split("\n")[0]
    elsif r.body.length > LIST_RECORD_TRUNCATE
      "#{r.body[0..LIST_RECORD_TRUNCATE]}..."
    else
      r.body
    end
    puts "[" + ("%02d" % i) + "] #{body}".ljust(LIST_RECORD_TRUNCATE) + "#{r.created_at.strftime(TIME_DATE_FORMAT).rjust(5)}"
  end

  def self.puts_full_record(r)
    puts r.body
    puts r.created_at
    puts "TAGGED: #{r.tags.join(', ')}"
  end

  def self.puts_list_task(t, i)
    puts "[#{i}] #{t.body} #{t.priority}"
  end
end

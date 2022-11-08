INDENT_LEVEL = 2

class Printer
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
    Printer.puts_indented 'RECORD ADDED'
    Printer.puts_dashes
    puts r.body
    puts "tags: #{r.tags}"
    puts r.created_at
    Printer.puts_dashes
  end

  def self.puts_new_task(t)
    Printer.puts_indented 'TASK ADDED'
    Printer.puts_dashes
    puts t.body
    puts t.created_at
    Printer.puts_dashes
  end

  def self.puts_prompt_title(t)
    Printer.puts_dashes
    puts t
  end

  def self.puts_list_record(r)
    puts "#{r.id}:[#{r.created_at}] |#{r.tags.join(', ')}| -- #{r.body[0..40]}..."
    Printer.puts_dashes
  end

  def self.puts_full_record(r)
    puts r.created_at
    puts r.body
    puts "TAGGED: #{r.tags.join(', ')}"
  end
end

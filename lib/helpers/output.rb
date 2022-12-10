alias standard_puts puts

module Format
  def self.bold(s); format(s, 1) end
  def self.underline(s); format(s, 4) end
  def self.reverse(s); format(s, 7) end

  def self.black(s); format(s, 30) end
  def self.red(s); format(s, 31) end
  def self.green(s); format(s, 32) end
  def self.brown(s); format(s, 32) end
  def self.blue(s); format(s, 34) end
  def self.magenta(s); format(s, 35) end
  def self.cyan(s); format(s, 36) end
  def self.gray(s); format(s, 37) end

  private

  def self.format(str, code)
    "\e[#{code}m#{str}\e[0m"
  end
end

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
    puts "|  #{Format.underline Format.bold s}  |"
    puts '=' * (s.length + 6)
  end

  def self.puts_underlined(s)
    puts Format.underline s
  end

  def self.puts_indented(s, indent=1)
    puts '-' * (indent * INDENT_LEVEL) + "> #{s}" 
  end

  def self.clear
    system('clear')
  end

  def self.log(*args)
    args.each{ |it| puts Format.gray '~ ' + it }
  end

  def self.error(s, error_type = "error")
    puts Format.red "#{error_type}: #{s}"
  end

  def self.puts_new_record(r)
    puts r.body
    puts "tags: #{r.tags.join(', ')}"
    puts r.created_at.strftime(TIME_DATE_FORMAT)
  end

  def self.puts_new_task(t)
    puts t.body
    puts t.priority
    puts t.created_at
  end

  def self.print_title
    Output.clear
    Output.puts_in_box "RUBERT"
    Output.puts_newline
  end

  def self.puts_prompt_title(t)
    puts Format.gray Format.underline t
  end

  def self.puts_list_record(r, i)
    body = if r.body[0..LIST_RECORD_TRUNCATE].match("\n")
      r.body[0..LIST_RECORD_TRUNCATE].split("\n")[0]
    elsif r.body.length > LIST_RECORD_TRUNCATE
      "#{r.body[0..(LIST_RECORD_TRUNCATE - 3)]}..."
    else
      r.body
    end
    puts  " " + ("%02d" % i) + "#{r.class == Task ? " | p#{("%02d" % r.priority)} |" : ""} " + "#{body}".ljust(LIST_RECORD_TRUNCATE + 3) + (Format.gray "#{r.created_at.strftime(TIME_DATE_FORMAT)}")
  end

  def self.puts_list_ledger(l, i)
    puts "#{i} | #{l.split('.')[0]}"
  end

  def self.puts_full_record(r)
    puts r.body
    puts "TAGGED: #{r.tags.join(', ')}"
    puts r.created_at.strftime(TIME_DATE_FORMAT)
  end

  def self.puts_between_lines
    puts_dashes
    yield
    puts_dashes
  end
end

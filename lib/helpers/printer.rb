

class Printer
  def self.put_dashes(l=20)
    puts '-' * l
  end

  def self.put_newline
    puts "\n"
  end

  def self.print_title(s)
    put_newline
    put_dashes s.length + 4
    put "| {s} |"
    put_dashes s.length + 4
    put_newline
  end
end

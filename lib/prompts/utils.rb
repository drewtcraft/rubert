module GetBody
  private
  def get_body(msg)
    Output.puts msg
    Input.multiline_gets
  end
end

module GetTags
  private
  def get_tags
    Output.puts "enter comma-separated tags:"
    tags = Input.one_line_gets
    tags.split(',')
      .map {|t| t.strip}
      .select {|t| t != ''}
  end
end

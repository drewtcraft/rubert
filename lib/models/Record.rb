require 'securerandom'

class Record
  attr_reader :id, :body, :tags, :created_at

  def initialize(params)
    @id = params[:id]
    @body = params[:body]
    @tags = params[:tags]
    @created_at = params[:created_at]
  end

  def new_from_parts(body, tags)
    created_at = Time.now
    Record.new {id: SecureRandom.uuid, body:, tags:, created_at:}
  end
end

require 'securerandom'
require_relative './base'

class Record < Timestamped
  attr_reader :id, :body, :tags

  def initialize(params)
    super 
    @id = params[:id]
    @body = params[:body]
    @tags = params[:tags]
  end

  def self.new_from_parts(body, tags)
    updated_at = created_at = Time.now
    Record.new ({
      id: SecureRandom.uuid, 
      body:, 
      tags:, 
      created_at:,
      updated_at:,
    })
  end

  def update(body: nil, tags: nil)
    super()
    if body
      @body = body
    elsif tags
      @tags = tags
    end
  end

  def to_hash
    {
      id: @id,
      body: @body,
      tags: @tags,
      created_at: @created_at,
      update_at: @updated_at,
    }
  end
end

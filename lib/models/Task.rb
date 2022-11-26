require 'securerandom'
require_relative './Record'

class Task < Record
  DEFAULT_PRIORITY = 5
  def initialize(params)
    super 
    @priority = params[:priority]
    @completed = params[:completed]
  end

  def update(priority: nil, completed: nil, body: nil, tags: nil)
    super(body:, tags:)
    if priority
      @priority = priority
    elsif completed
      @completed = completed
    end
  end

  def self.new_from_parts(body, tags, priority)
    updated_at = created_at = Time.now
    self.new ({
      id: SecureRandom.uuid, 
      body:, 
      tags:, 
      priority:,
      created_at:,
      updated_at:,
      completed: false,
    })
  end

  def to_hash
    {
      id: @id,
      body: @body,
      tags: @tags,
      completed: @completed,
      priority: @priority,
      created_at: @created_at,
      updated_at: @updated_at
    }
  end
end

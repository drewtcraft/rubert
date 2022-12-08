require 'securerandom'
require_relative './Record'

class Task < Record
  DEFAULT_PRIORITY = 5
  attr_accessor :priority, :done
  def initialize(params)
    super 
    @priority = params[:priority]
    @done = params[:done]
  end

  def update(priority: nil, done: nil, body: nil, tags: nil)
    super(body:, tags:)
    if priority
      @priority = priority
    elsif done
      @done = done
    end
  end

  def self.new_from_parts(body, tags, priority)
    new({
      priority:,
      done: false,
      **super(body, tags)
    })
  end

  def to_hash
    {
      done: @done,
      priority: @priority,
      **super,
    }
  end
end

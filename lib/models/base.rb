class Timestamped
  attr_reader :created_at, :updated_at

  def initialize(params)
    @created_at = params[:created_at]
    @updated_at = params[:updated_at]
  end

  def update
    @updated_at = Time.now
  end
end

class ServiceError

  attr_reader :data
  attr_reader :error

  def initialize(data, error)
    @data = data
    @error = error
  end

  def success?
    false
  end

end

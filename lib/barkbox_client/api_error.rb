class BarkboxClient::ApiError < StandardError
  attr_accessor :status, :errors

  def initialize(response)
    @status = response.status
    begin
      @errors = JSON.parse(response.body, symbolize_names: true)[:errors]
      @errors = {general: errors} if errors.is_a?(String)
    rescue => e
      @errors = {general: e.message}
    end
  end

  def pretty_errors
    return @errors if @errors.nil? || @errors.is_a?(String)

    @errors.map { |k, v| "#{k} #{v}" }.join(", ")
  end

  def message
    pretty_errors
  end
end

class BarkboxClient::UnauthenticatedError < StandardError ; end

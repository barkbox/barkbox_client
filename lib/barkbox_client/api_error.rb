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
    case @errors
    when String
      @errors
    when Hash
      @errors.map { |k, v| "#{k} #{v}" }.join(", ")
    when NilClass
      "@errors was nil"
    else
      "Unknown error format: #{@errors}"
    end
  end

  def message
    pretty_errors
  end
end

class BarkboxClient::UnauthenticatedError < StandardError ; end

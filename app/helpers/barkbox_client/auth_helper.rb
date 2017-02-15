module BarkboxClient
  module AuthHelper

    def authenticate!
      ok = BarkboxClient.auth_class.verify(request_token)
      raise BarkboxClient::UnauthenticatedError unless ok
    end

    def request_token
      if request.env['Authorization'].present?
        return request.env['Authorization'].gsub('Bearer ', '')
      elsif params[:access_token].present?
        return params[:access_token]
      end
    end

  end
end

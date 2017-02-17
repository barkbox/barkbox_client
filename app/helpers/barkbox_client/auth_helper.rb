module BarkboxClient
  module AuthHelper

    def login!
      auth = BarkboxClient.auth_class.login(params[:email], params[:password])
      raise BarkboxClient::UnauthenticatedError unless auth.present?
    end

    def authenticate!
      auth = BarkboxClient.auth_class.verify(request_token)
      raise BarkboxClient::UnauthenticatedError unless auth.present?
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

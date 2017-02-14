module BarkboxClient
  module AuthHelper

    def authenticate!
      auth = BarkboxClient.auth_class.find_by_access_token(request_token)
      success = !BarkboxClient.user_token(auth).expired?
      raise BarkboxClient::Unauthenticated unless success
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

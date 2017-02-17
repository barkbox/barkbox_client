require "json"
require "logger"
require "oauth2"
require "barkbox_client/version"
require "barkbox_client/api_error"
require "barkbox_client/configuration"
require "barkbox_client/engine"

module BarkboxClient

  class << self

    def configure
      yield config if block_given?
    end

    def json response
      headers = {}
      headers[:expires] = response.headers['Expires']
      body = JSON.parse(response.body, symbolize_names: true)
      return body.merge({headers: headers})
    end

    def app protocol, path, params={}
      response = app_request(protocol, path, params)
      raise ApiError.new(response) unless (response.status == 200)
      return json(response)
    end

    def ok? protocol, path, params={}
      response = app_request(protocol, path, params)
      return (response.status == 200)
    end
    
    def app_request protocol, path, params={}
      path = '/api/v2/' + path unless path.include?('http')
      @app_token = nil if app_token.expired?
      response = app_token.send(protocol.to_s, path, options_for(protocol, params))
      response
    end

    def system protocol, path, params={}
      path = '/api/v2/' + path unless path.include?('http')
      token = OAuth2::AccessToken.new(client, barkbox_oauth_token)
      token.refresh! if token.expired?
      response = token.send(protocol.to_s, path, options_for(protocol, params))
      raise ApiError.new(response) unless (response.status == 200)
      return json(response)
    end

    def user local_token, protocol, path, params={}
      path = '/api/v2/' + path unless path.include?('http')
      response = user_token(local_token).send(protocol.to_s, path, options_for(protocol, params))
      raise ApiError.new(response) unless (response.status == 200)
      return json(response)
    end

    def login email, password
      oauth_token = client.password.get_token(email, password)
      if oauth_token.nil? || oauth_token.token.nil? || oauth_token.token.empty?
        return nil
      end
      oauth_token
    end

    def verify local_token
      oauth_token = user_token(local_token)
      oauth_token = oauth_token.refresh! if oauth_token.try(:expired?)
      if oauth_token.nil? || oauth_token.token.nil? || oauth_token.token.empty?
        return nil
      end
      oauth_token
    end

    def me local_token
      BarkboxClient.user(local_token, :get, 'me')
    end

    def user_token local_token
      OAuth2::AccessToken.new(client, local_token.access_token, {
        access_token_expires_at: local_token.access_token,
        refresh_token: local_token.refresh_token
      })
    end

    def client
      @instance ||= OAuth2::Client.new(app_id, barkbox_secret, {site: barkbox_auth_url, raise_errors: false})
    end

    def app_token
      @app_token ||= client.client_credentials.get_token
    end

    def app_id
      @app_id ||= ENV['BARKBOX_APP_ID']
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def barkbox_secret
      @barkbox_secret ||= ENV['BARKBOX_SECRET']
    end

    def barkbox_auth_url
      @barkbox_auth_url ||= ENV['BARKBOX_AUTH_URL']
    end

    def barkbox_oauth_token
      @barkbox_oauth_token ||= ENV['BARKBOX_OAUTH_TOKEN']
    end

    def auth_class
      @auth_class ||= BarkboxClient::Auth
    end

  private

  def config
    @config ||= Configuration.new(self)
  end

  def body_methods
    @body_methods ||= %w(post put patch)
  end

  def param_methods
    @param_methods ||= %w(get delete)
  end

  def options_for protocol, params
    protocol = protocol.to_s.downcase
    options = { headers: { 'Content-Type' => 'application/json'} }
    if body_methods.include?(protocol) 
      options.merge({ body: params.to_json })
    elsif param_methods.include?(protocol)
      options.merge({ params: params })
    else
      raise "#{protocol} is not a valid HTTP verb"
    end
  end

  end
end

require "json"
require "logger"
require "oauth2"
require "barkbox_client/version"
require "barkbox_client/api_error"
require "barkbox_client/configuration"

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
      response = app_request(protocol, path, options_for(protocol, params))
      return (response.status == 200)
    end
    
    def log type, path, params
      logger.info "[api request][#{type}]: #{path}"
      logger.info "[api request][#{type}]: #{params.except(:credit_card, :password, :password_confirmation)}"
    end

    def app_request protocol, path, params={}
      path = '/api/v2/' + path unless path.include?('http')
      log('app', path, params)
      @app_token = nil if app_token.expired?
      response = app_token.send(protocol.to_s, path, options_for(protocol, params))
      response
    end

    def system protocol, path, params={}
      path = '/api/v2/' + path unless path.include?('http')
      log('system', path, params)
      token = OAuth2::AccessToken.new(client, barkbox_oauth_token)
      token.refresh! if token.expired?
      response = token.send(protocol.to_s, path, options_for(protocol, params))
      logger.info "[api response][system]: #{response.inspect}"
      raise ApiError.new(response) unless (response.status == 200)
      return json(response)
    end

    def user user, protocol, path, params={}
      path = '/api/v2/' + path unless path.include?('http')
      log('user', path, params)
      token = OAuth2::AccessToken.new(client, user.access_token)
      token.refresh! if token.expired?
      response = token.send(protocol.to_s, path, options_for(protocol, params))
      logger.info "[api response][user]: #{response.inspect}"
      raise ApiError.new(response) unless (response.status == 200)
      return json(response)
    end

    def user_token_from_credentials email, password
      response = client.password.get_token(email, password)
      if response.nil? || response.token.nil? || response.token.empty?
        return nil
      end
      logger.info "[api response][user_token_from_credentials]: #{response.inspect}"
      return response
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
    protocol = protocol.dup.to_s.downcase
    if body_methods.include?(protocol) 
      { body: params }
    elsif param_methods.include?(protocol)
      { params: params }
    else
      raise "#{protocol} is not a valid HTTP verb"
    end
  end

  end
end

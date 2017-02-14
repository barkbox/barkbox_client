module BarkboxClient
  class Auth < ActiveRecord::Base

    def update_from_oauth2_access_token token
      access_token = token.access_token
      access_token_expires_at = token.expires_at
      refresh_token = token.expires_at
      save
    end

  end
end

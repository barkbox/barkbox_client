module BarkboxClient
  class Auth < ActiveRecord::Base

    def expired?
      access_token_expires_at.present? && access_token_expires_at < Time.zone.now
    end

    def verify
      puts "EXPIRED? #{expired?.inspect}"
      refresh! if expired?
      puts "EXPIRED? #{expired?.inspect}"
      !expired?
    end

    def refresh
      oauth_token = BarkboxClient.verify(self)
      puts "OAUTH TOKEN: #{oauth_token.to_hash}"
      self.access_token = oauth_token.token
      self.access_token_expires_at = oauth_token.expires_at
      self.refresh_token = oauth_token.refresh_token
      sync_from_barkbox
    end

    def refresh!
      refresh
      save!
    end

    def sync_from_barkbox
      bb_user = BarkboxClient.me(self)
      self.email = bb_user[:email]
    end

    def sync_from_barkbox!
      sync_from_barkbox
      save!
    end

    class << self

      def verify access_token
        auth = where(access_token: access_token).first
        auth.present? ? auth.verify : false
      end
    end
  end
end

module BarkboxClient
  class Auth < ActiveRecord::Base

    def expired?
      access_token_expires_at.present? && access_token_expires_at < Time.zone.now
    end

    def verify
      refresh! if expired? || refresh_token.blank?
      !expired?
    end

    def verify!
      verify
      save!
    end

    def refresh
      oauth_token = BarkboxClient.verify(self)
      if oauth_token.nil? || oauth_token.token.blank?
        self.access_token_expires_at = Time.zone.now
      else
        update_from_oauth_token(oauth_token)
        sync_from_barkbox
      end
    end

    def refresh!
      refresh
      save!
    end

    def update_from_oauth_token oauth_token
      self.access_token = oauth_token.token
      self.access_token_expires_at = oauth_token.expires_at
      self.refresh_token = oauth_token.refresh_token
    end

    def sync_from_barkbox
      data = BarkboxClient.me(self)
      puts "BEFORE: #{self.inspect}"
      p data
      self.email = data[:user][:email]
      self.barkbox_user_id = data[:user][:id]
    end

    def sync_from_barkbox!
      sync_from_barkbox
      save!
    end

    class << self

      def verify access_token
        auth = where(access_token: access_token).first_or_initialize
        auth.verify!
      end

      def login email, password
        oauth_token = BarkboxClient.login(email, password)
        auth = where(access_token: oauth_token.token).first_or_initialize do |auth|
          auth.update_from_oauth_token(oauth_token)
        end
        auth.sync_from_barkbox!
        auth
      end

    end
  end
end

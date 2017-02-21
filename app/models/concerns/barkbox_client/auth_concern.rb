module BarkboxClient
  module AuthConcern
    extend ActiveSupport::Concern

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
      update_from_barkbox_user_data(data[:user])
    end

    def sync_from_barkbox!
      sync_from_barkbox
      save!
    end

    # Override to store additional information like email, full_name, etc
    def update_from_barkbox_user_data user_data
      self.barkbox_user_id = user_data[:id]
    end

    class_methods do

      def verify access_token
        return nil if access_token.blank?
        auth = where(access_token: access_token).first_or_initialize
        auth.verify!
        auth.expired? ? nil : auth
      end

      def login email, password
        oauth_token = BarkboxClient.login(email, password)
        return nil if oauth_token.nil?
        auth = where(access_token: oauth_token.token).first_or_initialize do |auth|
          auth.update_from_oauth_token(oauth_token)
        end
        auth.sync_from_barkbox!
        auth.expired? ? nil : auth
      end

    end
  end
end

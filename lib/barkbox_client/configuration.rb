class BarkboxClient::Configuration
      attr_accessor :instance

      def initialize(instance)
        @instance = instance
      end

      def logger=(logger)
        instance.instance_variable_set(:@logger, logger)
      end

      def app_id=(id)
        instance.instance_variable_set(:@app_id, id)
      end

      def barkbox_secret=(secret)
        instance.instance_variable_set(:@barkbox_secret, secret)
      end

      def barkbox_auth_url=(url)
        instance.instance_variable_set(:@barkbox_auth_url, url)
      end

      def barkbox_oauth_token=(token)
        instance.instance_variable_set(:@barkbox_oauth_token, token)
      end
end
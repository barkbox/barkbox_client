module BarkboxClient
  class << self
    def reset
      [:@app_token, :@config, :@app_id, :@logger, :@barkbox_secret, :@barkbox_auth_url, :@client].each do |instance_variable|
        self.instance_variable_set(instance_variable, nil)
      end
    end
  end
end
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'barkbox_client'
require 'support/barkbox_client_reset'

RSpec.configure do |config|

  config.before(:each) do
    BarkboxClient.reset
  end

end

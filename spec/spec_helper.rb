$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'barkbox_client'
require 'support/barkbox_client_reset'
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../spec/dummy/db/migrate", __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)

RSpec.configure do |config|

  config.before(:each) do
    BarkboxClient.reset
  end

end

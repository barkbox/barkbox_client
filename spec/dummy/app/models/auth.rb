class Auth < ApplicationRecord
  include BarkboxClient::AuthConcern
end


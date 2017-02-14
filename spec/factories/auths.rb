FactoryGirl.define do
  sequence :barkbox_user_id do |n|
    n
  end

  sequence :email do |n|
    "test#{n}@example.com"
  end

  sequence :token do 
    SecureRandom::hex
  end

  factory :auth, class: BarkboxClient::Auth do
    barkbox_user_id { generate(:barkbox_user_id) }
    email { generate(:email) }
    access_token { generate(:token) }
    refresh_token { generate(:token) }
  end
end

Rails.application.routes.draw do
  mount BarkboxClient::Engine => "/barkbox_client"

  post '/login' => 'test_controller#login'
  post '/authenticated' => 'test_controller#authenticated'
end

Rails.application.routes.draw do
  mount BarkboxClient::Engine => "/barkbox_client"

  post '/login' => 'test#login'
  post '/authenticated' => 'test#authenticated'
end

Rails.application.routes.draw do
  mount BarkboxClient::Engine => "/barkbox_client"
end

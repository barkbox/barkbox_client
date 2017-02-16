class TestController < ApplicationController
  include BarkboxClient::AuthHelper

  before_action :authenticate!, only: [:authenticated]

  def login
    BarkboxClient.auth_class.login(params[:email], params[:password])
    head :ok
  end

  def authenticated
    head :ok
  end
end

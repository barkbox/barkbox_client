class TestController < ApplicationController
  include BarkboxClient::AuthHelper

  before_action :login!, only: [:login]
  before_action :authenticate!, only: [:authenticated]

  def login
    head :ok
  end

  def authenticated
    head :ok
  end
end

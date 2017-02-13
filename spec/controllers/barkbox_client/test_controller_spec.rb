require 'spec_helper'

describe 'Authenticated requests' do

  it 'authenticates via username and password' do
    post :login, {email: 'test@barkbox.com', password: 'barkbarkgoose'}
    expect(response).to be_ok
    expect(BarkboxClient::AccessToken.last.email).to eq('test@barkbox.com')
  end

  it 'authenticates via token parameter' do
    token = BarkboxClient::AccessToken.create(access_token: '12345', last_validated_at: 2.minutes.ago)
    get :authenticated, {access_token: token.access_token}
    expect(response).to be_ok
  end

  it 'authenticates via recent bearer token' do
    token = BarkboxClient::AccessToken.create(access_token: '12345', last_validated_at: 2.days.ago)
    @request.headers['Authorization'] = "Bearer #{token.access_token}"
    get :authenticated
    expect(response).to be_ok
  end

  it 'reauthenticates via stale bearer token' do
    token = BarkboxClient::AccessToken.create(access_token: '12345', last_validated_at: 2.days.ago)
    @request.headers['Authorization'] = "Bearer #{token.access_token}"
    get :authenticated
    expect(response).to be_ok
  end

  it 'does not authenticate with expired stale bearer token' do
    token = BarkboxClient::AccessToken.create(access_token: '12345', last_validated_at: 2.days.ago)
    @request.headers['Authorization'] = "Bearer #{token.access_token}"
    get :authenticated
    expect(response).to be_unauthenticated
  end

  it 'does not authenticate without credentials' do
    get :authenticated
    expect(response).to be_unauthenticated
  end

end

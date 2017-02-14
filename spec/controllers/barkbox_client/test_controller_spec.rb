require 'rails_helper'

describe TestController do

  it 'authenticates via username and password' do
    post :login, {email: 'test@barkbox.com', password: 'barkbarkgoose'}
    expect(response).to be_ok
    expect(BarkboxClient::Auth.last.email).to eq('test@barkbox.com')
  end

  it 'authenticates via token parameter' do
    token = create(:auth)
    get :authenticated, {access_token: token.access_token}
    expect(response).to be_ok
  end

  it 'authenticates via recent bearer token' do
    token = create(:auth)
    request.env['Authorization'] = "Bearer #{token.access_token}"
    get :authenticated
    expect(response).to be_ok
  end

  it 'reauthenticates via expired bearer token' do
    token = create(:auth, access_token_expires_at: Time.zone.now - 2.days)
    request.env['Authorization'] = "Bearer #{token.access_token}"
    get :authenticated
    expect(response).to be_ok
  end

  it 'does not authenticate with expired stale bearer token' do
    token = create(:auth)
    request.env['Authorization'] = "Bearer #{token.access_token}"
    get :authenticated
    expect(response).to be_unauthenticated
  end

  it 'does not authenticate without credentials' do
    get :authenticated
    expect(response).to be_unauthenticated
  end

end

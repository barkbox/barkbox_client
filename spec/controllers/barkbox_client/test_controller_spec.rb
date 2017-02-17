require 'rails_helper'

describe TestController do

  before do
    BarkboxClient.configure do |config|
      config.app_id = '1234'
      config.barkbox_secret = 'XXXXXXXXXXXXXXX'
      config.barkbox_oauth_token = 'XXXXXXXXXXXXXXX'
      config.barkbox_auth_url = 'http://example.com'
      config.auth_class = Auth
    end
    me_json = {
      user: {
        api_version: 2,
        id: 6789,
        first_name: "Test",
        last_name: "User",
        email: "test@example.com",
        phone_number: "",
        roles: ["user"],
        created_at: "2012-08-09 17:41",
        updated_at: "2017-02-15 10:38",
        was_referred: true,
        donate_referrals: false,
        referral_coupon_code: "BARKBARK",
        referral_bonus_month_count: 0,
        provider: nil,
        is_new_subscriber: false
      },
      meta: {
        status: 200
      }
    }
    stub_request(:get, /api\/v2\/me/).to_return(body: me_json.to_json)
  end

  it 'authenticates via username and password' do
    oauth_token = OAuth2::AccessToken.new(BarkboxClient.client, 'new_token', {
      refresh_token: 'refresh_token', expires_at: Time.zone.now + 1.day
    })
    expect(BarkboxClient).to receive(:login) { oauth_token }
    post :login, {email: 'test@example.com', password: 'barkbarkgoose'}
    expect(response).to be_ok
    expect(BarkboxClient::Auth.last.email).to eq('test@example.com')
  end

  it 'authenticates via token parameter' do
    token = create(:auth)
    get :authenticated, {access_token: token.access_token}
    expect(response).to be_ok
  end

  it 'authenticates with valid access_token without existing local record'

  it 'authenticates via recent bearer token' do
    token = create(:auth)
    request.env['Authorization'] = "Bearer #{token.access_token}"
    get :authenticated
    expect(response).to be_ok
  end

  it 'reauthenticates via expired bearer token' do
    oauth_token = OAuth2::AccessToken.new(BarkboxClient.client, 'new_token', {
      refresh_token: 'refresh_token', expires_at: Time.zone.now + 1.day
    })
    expect(BarkboxClient).to receive(:verify) { oauth_token }
    token = create(:auth, access_token_expires_at: Time.zone.now - 2.days)
    request.env['Authorization'] = "Bearer #{token.access_token}"
    get :authenticated
    expect(response).to be_ok
  end

  it 'does not authenticate with expired stale bearer token' do
    oauth_token = OAuth2::AccessToken.from_hash(BarkboxClient.client, {"error"=>"invalid_grant", "error_description"=>"The provided authorization grant is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client.", :access_token=>"", :refresh_token=>nil, :expires_at=>nil})
    expect(BarkboxClient).to receive(:verify) { oauth_token }
    token = create(:auth, access_token_expires_at: Time.zone.now - 1.day)
    request.env['Authorization'] = "Bearer #{token.access_token}"
    expect{ get :authenticated }.to raise_error(BarkboxClient::UnauthenticatedError)
  end

  it 'does not authenticate without credentials' do
    expect{ get :authenticated }.to raise_error(BarkboxClient::UnauthenticatedError)
  end

  it 'does not login without credentials' do
    expect(BarkboxClient).to receive(:login) { nil }
    expect{ post :login }.to raise_error(BarkboxClient::UnauthenticatedError)
  end

end

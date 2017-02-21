require 'rails_helper'

describe BarkboxClient do
  it 'has a version number' do
    expect(BarkboxClient::VERSION).not_to be nil
  end

  context 'Configuration' do

    describe ".configure" do
      
      it "yield's the clients configuration object" do
        BarkboxClient.configure do |config|
          expect(config).to be_a(BarkboxClient::Configuration)
          expect(config).to eq(BarkboxClient.send(:config))
        end
      end

      context "configuration methods" do
        let(:logger){ Logger.new(STDOUT) }
        let(:app_id){ '1234' }
        let(:barkbox_secret){ 'XXXXXXXXXXXXXXX' }
        let(:barkbox_oauth_token){ 'XXXXXXXXXXXXXXX' }
        let(:barkbox_auth_url){ 'https://dev.barkbox.com/auth' }

        [:logger, :app_id, :barkbox_secret, :barkbox_auth_url, :barkbox_oauth_token].each do |method|
          describe ".#{method.to_s}=" do
            it "sets the #{method.to_s} to be used by the client" do
              value = eval "#{method.to_s}"
              method_name = "#{method.to_s}="

              BarkboxClient.configure do |config|
                config.send(method_name, value)
              end

              expect(BarkboxClient.send(method)).to eq(value)
            end
          end
        end

      end
    end
  
    context "Defaults" do
      describe ".logger" do
        it "defaults to a new instance of Logger" do
          expect(BarkboxClient.logger).to be_a(Logger)
        end
      end

      describe ".app_id" do
        it "defaults to the value of ENV['BARKBOX_APP_ID']" do
          ENV['BARKBOX_APP_ID'] = '123456'
          expect(BarkboxClient.app_id).to eq(ENV['BARKBOX_APP_ID']) 
        end
      end

      describe ".barkbox_secret" do
        it "defaults to the value of ENV['BARKBOX_SECRET']" do
          ENV['BARKBOX_SECRET'] = 'XXXXXXXXXXXXXXX'
          expect(BarkboxClient.barkbox_secret).to eq(ENV['BARKBOX_SECRET']) 
        end
      end

      describe ".barkbox_auth_url" do
        it "defaults to the value of ENV['BARKBOX_AUTH_URL']" do
          ENV['BARKBOX_AUTH_URL'] = 'https://some.url'
          expect(BarkboxClient.barkbox_auth_url).to eq(ENV['BARKBOX_AUTH_URL'])
        end
      end

      describe ".barkbox_oauth_token" do
        it "defaults to the value of ENV['BARKBOX_OAUTH_TOKEN']" do
          ENV['BARKBOX_OAUTH_TOKEN'] = 'https://some.url'
          expect(BarkboxClient.barkbox_auth_url).to eq(ENV['BARKBOX_OAUTH_TOKEN'])
        end
      end
    end

  end

end

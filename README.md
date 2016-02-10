# BarkboxClient

A Ruby API client for Barkbox.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'barkbox_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install barkbox_client

## Usage

BarkboxClient requires several configuration variables to be set before usage. These variables can be set through the environment, or through the `.configure` method. Values set with `.configure` take precedence over values set through the environment.

```ruby

require 'barkbox_client'

BarkboxClient.configure do |config|
	# Any object that implements the Ruby logger interface. Defaults to Logger.new(STDOUT)
	config.logger = Rails.logger 
	# The application id to be used for requests to Barkbox. Defaults to ENV['BARKBOX_APP_ID']
	config.app_id = '12345'
	# The secret key to be used for requests to Barkbox. Defaults to ENV['BARKBOX_SECRET']
	config.barkbox_secret = 'XXXXXXXXXXX'
	# The URL to use for authorization with Barkbox. Defaults to ENV['BARKBOX_AUTH_URL']
	config.barkbox_auth_url = 'https://some.url'
	# The oAuth token for the application. Defaults to ENV['BARKBOX_OAUTH_TOKEN']
	config.barkbox_oauth_token = 'SOMEREALLYLONGSTRING'
end

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/barkbox/barkbox_client.


# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'barkbox_client/version'

Gem::Specification.new do |spec|
  spec.name          = "barkbox_client"
  spec.version       = BarkboxClient::VERSION
  spec.authors       = ["Erik Sälgström Peterson"]
  spec.email         = ["erik@barkbox.com"]

  spec.summary       = %q{Client library for the BarkBox API}
  spec.homepage      = "https://github.com/barkbox/barkbox_client"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 4.2.5.2"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "rspec-rails", "~> 3.5"
  spec.add_development_dependency "factory_girl_rails"
  spec.add_development_dependency "webmock"

  spec.add_runtime_dependency "multi_json"
  spec.add_runtime_dependency "oauth2", "~> 1.4.0"
end

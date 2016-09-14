# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dashing_api/version'

Gem::Specification.new do |spec|
  spec.name          = "dashing_api"
  spec.version       = DashingApi::VERSION
  spec.authors       = ["FT"]
  spec.email         = ["jermila.dhas@ft.com"]
  spec.description   = "API for interaction with dashing"
  spec.summary       = "API for interaction with dashing"
  spec.homepage      = "https://github.com/Financial-Times/dashing_api.git"
  spec.license       = "MIT"

  spec.files         = Dir['README.md', 'lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  # Dashing and the TCP Ping class requires this
  spec.required_ruby_version = ">=1.9.3"

  spec.add_dependency "dashing", ">= 1.3.0"
  spec.add_dependency "net-ping", "~> 1.7"
  spec.add_dependency "nokogiri"
 
  spec.add_development_dependency "minitest", "~> 5.8.1"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "simplecov"
end


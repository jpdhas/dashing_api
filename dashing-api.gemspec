# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dashing/api/version'

Gem::Specification.new do |spec|
  spec.name          = "dashing-api"
  spec.version       = Dashing::Api::VERSION
  spec.authors       = ["FT"]
  spec.email         = ["Jermila.Dhas@ft.com"]
  spec.description   = "API for interaction with dashing"
  spec.summary       = "API for interaction with dashing"
  spec.homepage      = "https://github.com/Financial-Times/dashing-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "net-ping", "~> 1.7"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

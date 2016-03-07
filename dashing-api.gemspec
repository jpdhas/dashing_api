Gem::Specification.new do |s|
  s.name        = 'dashing-api'
  s.version     = '0.0.2'
  s.date        = '2015-10-08'
  s.summary     = "API for interaction with dashing"
  s.description = "API for interaction with dashing"
  s.authors     = ["FT"]
  s.email       = 'jermila.dhas@ft.com'
  s.files       = ["lib/helperFunctions.rb", "lib/dashing-api.rb"]
  s.homepage    =
    'http://rubygems.org/gems/dashing-api'
  s.license       = 'MIT'

  s.add_dependency('net-ping', '~> 1.7.0')
end

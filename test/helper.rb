require 'simplecov'
SimpleCov.start do
  add_filter "/vendor/"
  add_filter "/test/"
end

require 'dashing_api/api'
require 'rack/test'

PROJECT_CWD = Dir.pwd.freeze
ENV['RACK_ENV'] = 'test'

module DashingApi
  module TestHelper
    include Rack::Test::Methods
    
    def with_fixture(fixture='base')
      temp do |dir|
        FileUtils.copy_entry("#{PROJECT_CWD}/test/fixture/#{fixture}", 'fixture')

        app.set :auth_token, 'scoobydoo'
        app.set :default_dashboard, 'default_dashboard'

        app.settings.public_folder = File.join(dir, 'fixture/public')
        app.settings.views = File.join(dir, 'fixture/dashboards')
        app.settings.root = File.join(dir, 'fixture')
        yield app.settings.root
      end
    end
  
    def temp
      path = File.expand_path "#{Dir.tmpdir}/#{Time.now.to_i}#{rand(1000)}/"
      FileUtils.mkdir_p path
      Dir.chdir path
      yield path
    ensure
      Dir.chdir PROJECT_CWD
      FileUtils.rm_rf(path) if File.exist?(path)
    end

    def msg
      JSON.parse(last_response.body)['message']
    end

    def dashboard_file_exists(dashboard)
      File.exist? "fixture/dashboards/#{dashboard}.erb"
    end

    def dashboard_file_does_not_exist(dashboard)
      ! dashboard_file_exists(dashboard)
    end

    def app
      Sinatra::Application
    end
  end
end

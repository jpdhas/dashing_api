require 'helper'
require 'minitest/autorun'

class AppTest < MiniTest::Unit::TestCase
  include DashingApi::TestHelper

  def test_redirect_to_first_dashboard
    with_fixture do
      get '/'
      assert_equal 404, last_response.status
    end
  end

  def test_dashboard_list_with_no_dashboards
    with_fixture :empty do
      get '/dashboards/'
      assert_equal 200, last_response.status
      assert_equal '{"dashboards":[]}', last_response.body
    end
  end

  def test_dashboard_list_with_dashboards
    with_fixture :three_dashboards do
      get '/dashboards/'
      assert_equal 200, last_response.status
      assert_equal '{"dashboards":["dashboard1","dashboard2","default_dashboard"]}', last_response.body
    end
  end

  def test_check_dashboard_exists_when_dashboard_exists
    with_fixture :three_dashboards do
      get '/dashboards/dashboard1'
      assert_equal 200, last_response.status
      assert_equal '{"dashboard":"dashboard1","message":"Dashboard dashboard1 exists"}', last_response.body
    end
  end

  def test_check_dashboard_exists_when_dashboard_doesnt_exist
    with_fixture :three_dashboards do
      get '/dashboards/bananas'
      assert_equal 404, last_response.status
      assert_equal 'Dashboard bananas does not exist', msg
    end
  end

  def test_rename_dashboard
    with_fixture :three_dashboards do
      # rename
      payload = '{"auth_token": "scoobydoo", "from": "dashboard1", "to": "renamed_dashboard"}'
      put '/dashboards/', payload
      assert_equal 200, last_response.status
      assert_equal 'Dashboard Renamed from dashboard1 to renamed_dashboard', msg
      # check
      get '/dashboards/dashboard1'
      assert_equal 404, last_response.status
      get '/dashboards/renamed_dashboard'
      assert_equal 200, last_response.status
      assert dashboard_file_exists 'renamed_dashboard'
      assert dashboard_file_does_not_exist 'dashboard1'
    end
  end

  def test_rename_default_dashboard
    with_fixture :three_dashboards do
      payload = '{"auth_token": "scoobydoo", "from": "default_dashboard", "to": "renamed_dashboard"}'
      put '/dashboards/', payload
      assert_equal 200, last_response.status
      assert_equal 'Cannot rename the default dashboard default_dashboard', msg
    end
  end

  def test_rename_nonexistent_dashboard
    with_fixture :three_dashboards do
      payload = '{"auth_token": "scoobydoo", "from": "bananas", "to": "renamed_dashboard"}'
      put '/dashboards/', payload
      assert_equal 404, last_response.status
      assert_equal 'Dashboard bananas does not exist', msg
    end
  end

  def test_rename_dashboard_with_bad_api_key
    with_fixture :three_dashboards do
      payload = '{"auth_token": "bad_api_key", "from": "dashboard1", "to": "renamed_dashboard"}'
      put '/dashboards/', payload
      assert_equal 403, last_response.status
      assert_equal 'Invalid API Key!', msg
    end
  end
  
  def test_delete_dashboard
    with_fixture :three_dashboards do
      # delete
      payload = '{"auth_token": "scoobydoo"}'
      delete '/dashboards/dashboard1', payload
      assert_equal 202, last_response.status
      assert_equal 'Dashboard dashboard1 deleted', msg
      # check
      get '/dashboards/dashboard1'
      assert_equal 404, last_response.status
      assert dashboard_file_does_not_exist('dashboard1')
    end
  end

  def test_delete_default_dashboard
    with_fixture :three_dashboards do
      payload = '{"auth_token": "scoobydoo"}'
      delete '/dashboards/default_dashboard', payload
      assert_equal 404, last_response.status
      assert_equal 'Cannot delete the default dashboard' , msg
    end
  end

  def test_delete_nonexistent_dashboard
    with_fixture :three_dashboards do
      payload = '{"auth_token": "scoobydoo"}'
      delete '/dashboards/bananas', payload
      assert_equal 403, last_response.status
      assert_equal 'Dashboard bananas does not exist', msg
    end
  end

  def test_check_single_tile_exists
    with_fixture :three_dashboards do
      get '/tiles/dashboard1/tile1'
      assert_equal 200, last_response.status
      assert_equal 'Tiles exists on the dashboard', msg
    end
  end

  def test_check_multiple_tiles_exists
    with_fixture :three_dashboards do
      get '/tiles/dashboard1/tile1,tile2'
      assert_equal 200, last_response.status
      assert_equal 'Tiles exists on the dashboard', msg
    end
  end

  def test_check_multiple_tiles_exists_with_one_tile_missing
    with_fixture :three_dashboards do
      get '/tiles/dashboard1/tile1,tile99'
      assert_equal 404, last_response.status
      assert_equal 'Tiles tile99 does not exist on the dashboard dashboard1', msg
    end
  end

end

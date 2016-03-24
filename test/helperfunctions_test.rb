require 'minitest/autorun'

class HelperFunctionsTest < MiniTest::Unit::TestCase
  def setup
    @hf = HelperFunctions.new
  end

  def test_tokens_are_validated
    assert @hf.checkAuthToken({'auth_token'=>'token'},'token')
    refute @hf.checkAuthToken({'auth_token'=>'token'},'bad')
  end

  def test_tile_exists_finds_a_single_tile
    assert_equal @hf.tileExists(
      'dashboard1',
      'tile1',
      'test/fixture/three_dashboards',
    ), []
  end

  def test_tile_exists_finds_multiple_tiles
    assert_equal @hf.tileExists(
      'dashboard1',
      ['tile1','tile2'],
      'test/fixture/three_dashboards',
    ), []
  end

  def test_tile_exists_finds_missing_tiles
    assert_equal @hf.tileExists(
      'dashboard1',
      ['tile1','missing1','missing2'],
      'test/fixture/three_dashboards',
    ), ['missing1','missing2']

  end

  def test_dashboard_exists_finds_existing_dashboard
    assert @hf.dashboardExists(
      'dashboard1',
      'test/fixture/three_dashboards',
    )
  end

  def test_dashboard_exists_finds_missing_dashboard
    refute @hf.dashboardExists(
      'missingdashboard',
      'test/fixture/three_dashboards',
    )
  end

  def test_render_new_dashboard_template
    body = { 'tiles' => {
      'hosts'   => %w[ host1 host2 ],
      'widgets' => %w[ wid1 wid2 ],
      'titles'  => %w[ title1 title2 ],
      'urls'    => %w[ url1 url2 ],
    } }

    result = @hf.render(body, newDashboardTemplate)
    body['tiles']['hosts'].each do |host|
      assert(/data-id="#{host}"/.match(result), "template failed to match host")
    end
    body['tiles']['widgets'].each do |widget|
      assert(/data-view="#{widget}"/.match(result), "template failed to match widget")
    end
    body['tiles']['titles'].each do |title|
      assert(/data-title="#{title}"/.match(result), "template failed to match title")
    end
    body['tiles']['urls'].each do |url|
      assert(/data-url="#{url}"/.match(result), "template failed to match url")
    end
  end
end

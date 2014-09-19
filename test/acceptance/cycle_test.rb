require 'test_helper'

class CycleTest < Minitest::Test
  def setup
    @site = FakeSite.new("cycle_site")
  end

  def teardown
    @site.stop
  end

  def test_doesnt_follow_cycles
    crawler = Crawler.new(@site.url)
    crawler.crawl!

    assert_equal [
      {
        url: "http://localhost:4000/",
        links: ["http://localhost:4000/"],
        assets: []
      }
    ], crawler.pages
  end
end



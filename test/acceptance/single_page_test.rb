require 'test_helper'

class SinglePageTest < Minitest::Test
  def setup
    @site = FakeSite.new("single_page_site")
  end

  def teardown
    @site.stop
  end

  def test_crawls_single_page
    crawler = Crawler.new(@site.url)
    crawler.crawl!
    assert_equal [
      {
        path: "/",
        links: [],
        assets: []
      }
    ], crawler.pages
  end
end

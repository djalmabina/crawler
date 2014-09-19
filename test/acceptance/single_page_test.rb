require 'test_helper'

class SinglePageTest < Crawler::TestCase
  def setup
    super
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
        url: "http://localhost:4000/",
        links: [],
        assets: []
      }
    ], Crawler::Page.to_a
  end
end

require 'test_helper'

class MissingPageTest < Crawler::TestCase
  def setup
    @site = FakeSite.new("single_page_site")
  end

  def teardown
    @site.stop
  end

  def test_crawls_single_page
    crawler = Crawler.new(@site.url + "missing-page")
    crawler.crawl!
    assert_equal [
      {
        url: "http://localhost:4000/missing-page",
        links: [],
        assets: [],
        :"404" => true
      }
    ], Crawler::Page.to_a
  end
end


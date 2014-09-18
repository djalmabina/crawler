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
    assert_equal 1, crawler.pages.size
    page = crawler.pages.first
    assert_equal "/", page.path
    assert_empty page.assets
    assert_empty page.links
  end
end

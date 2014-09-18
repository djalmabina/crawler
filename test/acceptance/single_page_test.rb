require 'test_helper'

class SinglePageTest < Minitest::Test
  def test_crawls_single_page
    site = FakeSite.new("single_page_site")
    crawler = Crawler.new(site.url)
    crawler.crawl!
    assert_equal 1, crawler.pages.size
    page = crawler.pages.first
    assert_equal "/", page.url
    assert_empty page.assets
    assert_empty page.links
  end
end

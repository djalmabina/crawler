require 'test_helper'

class MultiPageTest < Minitest::Test
  def setup
    @site = FakeSite.new("multi_page_site")
  end

  def teardown
    @site.stop
  end

  def test_crawls_multiple_pages
    crawler = Crawler.new(@site.url)
    crawler.crawl!
    assert_equal 3, crawler.pages.size

    assert_equal ["/", "/about.html", "/privacy.html"], crawler.pages.map(&:path).sort

    index = crawler.pages.find{|p| p.path == "/" }
    refute_nil index
    assert_equal 3, index.assets.size

    js = index.assets.find{|a| a.path == "/js/app.js" }
    refute_nil js

    css = index.assets.find{|a| a.path == "/css/app.css" }
    refute_nil css

    image = index.assets.find{|a| a.path == "/images/logo.png"}
    refute_nil image

    assert_equal 2, index.links.size
    assert_equal ["/about.html", "/privacy.html"], index.links.sort
  end
end


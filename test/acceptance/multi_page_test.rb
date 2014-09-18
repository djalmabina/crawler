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

    assert_equal [
      {
        path: "/",
        links: ["/about.html", "/privacy.html"],
        assets: [
          "/css/app.css",
          "/images/logo.png",
          "/js/app.js"
        ]
      },
      {
        path: "/about.html",
        links: [],
        assets: []
      },
      {
        path: "/privacy.html",
        links: [],
        assets: []
      }
    ], crawler.pages
  end
end


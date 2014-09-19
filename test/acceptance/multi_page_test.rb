require 'test_helper'

class MultiPageTest < Crawler::TestCase
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
        url: "http://localhost:4000/",
        links: [
          "http://localhost:4000/about.html",
          "http://localhost:4000/privacy.html"
        ],
        assets: [
          "/css/app.css",
          "/images/logo.png",
          "/js/app.js"
        ]
      },
      {
        url: "http://localhost:4000/about.html",
        links: [],
        assets: []
      },
      {
        url: "http://localhost:4000/privacy.html",
        links: [],
        assets: []
      }
    ].sort_by{|p| p[:url]}, Crawler::Page.to_a.sort_by{|p| p[:url]}
  end
end


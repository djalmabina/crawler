require 'test_helper'

class PageTest < Crawler::TestCase
  def test_create_and_find_page
    page = Crawler::Page.new(url: "http://example.com")
    page.save

    assert_equal page, Crawler::Page.find("http://example.com")
  end

  def test_iterate_pages
    Crawler::Page.create(url: "http://example.com")

    assert_equal 1, Crawler::Page.count

    assert_equal "http://example.com", Crawler::Page.map{|p| p.url }.first
  end

  def test_find_nonexistent_page
    assert_nil Crawler::Page.find("foo")
  end
end

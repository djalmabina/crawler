require 'test_helper'

class CrawlerTest < Minitest::Test
  def setup
    @crawler = Crawler.new("http://example.com/")
  end

  def test_parse_relative_url
    path = @crawler.parse_url("/about_us#anchor?param=false")
    assert_equal "http://example.com/about_us#anchor?param=false", path.to_s
  end
  
  def test_parse_absolute_url
    path = @crawler.parse_url("http://example.com/about_us#anchor?param=false")
    assert_equal "http://example.com/about_us#anchor?param=false", path.to_s
  end

  def test_parse_external_url
    path = @crawler.parse_url("http://google.com/about_us#anchor?param=false")
    assert_equal nil, path
  end

  def test_parse_relative_url_with_anchor
    path = @crawler.parse_url("/about_us#anchor")
    assert_equal "http://example.com/about_us#anchor", path.to_s
  end

  def test_parse_relative_url_with_params
    path = @crawler.parse_url("/about_us?param=false")
    assert_equal "http://example.com/about_us?param=false", path.to_s
  end
end

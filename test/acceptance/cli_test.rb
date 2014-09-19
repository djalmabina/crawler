require 'test_helper'

class CliTest < Crawler::TestCase
  def setup
    super
    @site = FakeSite.new("single_page_site")
  end

  def teardown
    @site.stop
  end

  def test_crawls_single_page
    out, err = run_cli "http://localhost:4000"
    assert_equal JSON.pretty_generate([{:links=>[], :assets=>[], :url=>"http://localhost:4000"}]), out.strip
  end

  def test_invalid_usage
    out, err = run_cli
    assert_match /^Usage/, err
  end


  private
  def run_cli(*args)
    out = StringIO.new
    err = StringIO.new
    begin
      Crawler.cli(args, out, err)
    rescue SystemExit
      # squash
    end
    [out.string, err.string]
  end
end


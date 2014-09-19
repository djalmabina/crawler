require 'test_helper'

class CliTest < Crawler::TestCase
  def setup
    @site = FakeSite.new("single_page_site")
    FileUtils.rm_f("localhost.db")
  end

  def teardown
    @site.stop
  end

  def test_crawls_single_page
    out, _, _ = run_cli "http://localhost:4000"
    assert_equal JSON.pretty_generate([{:links=>[], :assets=>[], :url=>"http://localhost:4000"}]), out.strip
  end

  def test_invalid_usage
    _, err, _ = run_cli
    assert_match /^Usage/, err
  end


  private
  def run_cli(*args)
    out = StringIO.new
    err = StringIO.new
    log = StringIO.new
    begin
      Crawler.cli(args, out, err, log)
    rescue SystemExit
      # squash
    end
    [out.string, err.string, log.string]
  end
end


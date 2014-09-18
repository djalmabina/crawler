class Crawler
  autoload :Page, 'crawler/page.rb'

  def initialize(url)

  end

  def crawl!
  end

  def pages
    [Page.new]
  end
end

class Crawler::Page
  attr_reader :url

  def initialize(url: url)
    @url = url
  end

  def assets
    []
  end

  def links
    []
  end

  def path
    URI.parse(url).path
  end
end

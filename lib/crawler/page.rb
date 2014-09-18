class Crawler::Page
  attr_reader :url, :assets, :links

  def initialize(url: url, assets: [], links: [])
    @url = url
    @assets = assets
    @links = links
  end

  def path
    URI.parse(url).path
  end
end

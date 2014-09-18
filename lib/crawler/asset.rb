class Crawler::Asset
  attr_reader :path
  def initialize(path: nil)
    @path = path
  end
end

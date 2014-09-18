require 'capybara'
require 'open-uri'

class Crawler
  autoload :Page, 'crawler/page.rb'

  include Capybara::DSL

  attr_reader :pages

  def initialize(url)
    @root = url
    @pages = []
  end

  def crawl!
    crawl_page @root
  end

  def crawl_page(url)
    page = Capybara.string(open(URI.encode(url)).read)
    @pages << Page.new(url: url)
  end
end

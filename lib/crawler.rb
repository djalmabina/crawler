require 'nokogiri'
require 'open-uri'

class Crawler
  autoload :Page,  'crawler/page.rb'
  autoload :Asset, 'crawler/asset.rb'

  attr_reader :pages

  def initialize(url)
    @start = url
    @uri = URI.parse(url)
    @domain = "#{@uri.scheme}://#{@uri.host}:#{@uri.port}"
    @pages = []
  end

  def crawl!
    crawl_page @start
  end

  def crawl_page(url)
    # todo: move this to helper or a link class
    url = "#{@domain}#{url}" unless url =~ /^http/

    page = Nokogiri::HTML(open(URI.encode(url)).read)

    # todo: dry this up, maybe under Asset
    css    = page.css("link").select{|node| node["type"] == "text/css"}.map{|node| node["href"]}
    js     = page.css("script").map{|node| node["src"]}.compact
    images = page.css("img"   ).map{|node| node["src"]}

    assets = (css + js + images).map{|path| Asset.new(path: path)}

    # todo: move this to a Link class, also need to remove external links and add domain for relative links
    links = page.css("a").map{|node| node["href"]}

    @pages << Page.new(url: url, assets: assets, links: links)
    links.each do |link|
      crawl_page link
    end
  end
end

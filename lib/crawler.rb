require 'nokogiri'
require 'open-uri'

class Crawler
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

    # todo: move this to a Link class, also need to remove external links and add domain for relative links
    links = page.css("a").map{|node| node["href"]}.sort

    assets = (css + js + images).sort

    @pages << {path: URI.parse(url).path, links: links, assets: assets}
    links.each do |link|
      crawl_page link
    end
  end
end

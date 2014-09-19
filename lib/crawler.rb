require 'nokogiri'
require 'open-uri'

class Crawler
  attr_reader :pages

  def initialize(url)
    @start = url
    @uri   = URI.parse(url)
    @pages = []
  end

  def crawl!
    crawl_page @start
  end

  def crawl_page(url)
    uri = parse_url(url)
    return if uri.nil?

    page = parse_page(open(uri).read)
    page[:url] = uri.to_s

    @pages << page

    page[:links].each do |link|
      crawl_page link
    end
  end

  def parse_page(html)
    doc = Nokogiri::HTML(html)

    css    = doc.css(%{link[type="text/css"]}).map{|node| node["href"]}.compact
    js     = doc.css(%{script}               ).map{|node| node["src"] }.compact
    images = doc.css(%{img}                  ).map{|node| node["src"] }.compact
    links  = doc.css(%{a}                    ).map{|node| node["href"]}.compact.sort

    assets = (css + js + images).sort

    {
      links: links,
      assets: assets
    }
  end

  def parse_url(url)
    uri = @uri.merge(url)
    return nil if uri.host != @uri.host
    uri
  end
end

require 'nokogiri'
require 'open-uri'

class Crawler
  autoload :Page,      "crawler/page"
  autoload :GDBMStore, "crawler/gdbm_store"

  def initialize(url)
    @start = url
    @uri   = URI.parse(url)
  end

  def crawl!
    crawl_page @start
  end

  def crawl_page(url)
    uri = parse_url(url)
    return if uri.nil?

    page = parse_page(open(uri).read)
    page.url = uri.to_s

    page.save

    page[:links].each do |link|
      return if Page.find(link)
      crawl_page link
    end
  end

  def parse_page(html)
    doc = Nokogiri::HTML(html)

    css    = doc.css(%{link[type="text/css"]}).map{|node| node["href"]}.compact
    js     = doc.css(%{script}               ).map{|node| node["src"] }.compact
    images = doc.css(%{img}                  ).map{|node| node["src"] }.compact
    links  = doc.css(%{a}                    ).map{|node| node["href"]}.compact.sort

    links  = links.map{|l| parse_url(l).to_s }

    assets = (css + js + images).sort

    Page.new(
      links: links,
      assets: assets
    )
  end

  def parse_url(url)
    uri = @uri.merge(url)
    return nil if uri.host != @uri.host
    uri
  end
end

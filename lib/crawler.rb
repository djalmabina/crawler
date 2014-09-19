require 'nokogiri'
require 'open-uri'
require 'crawler/open_uri_redirection_patch'
require 'logger'
require 'json'

class Crawler
  autoload :Page,      "crawler/page"
  autoload :GDBMStore, "crawler/gdbm_store"
  attr_reader :logger
  attr_reader :uri

  def self.cli(args, io = $stdout, err = $stdout, logio = $stderr)
    if args.size != 1
      err.puts "Usage: crawler starting-uri"
      exit 1
    end
    crawler = new(args[0], Logger.new(logio))
    Crawler::Page.database_file "#{crawler.uri.host}.db"
    crawler.crawl!
    io.puts JSON.pretty_generate(Crawler::Page.to_a)
  end

  def initialize(url, logger = Logger.new(File.open("log/crawler.log", "a")))
    @start  = url
    @uri    = URI.parse(url)
    @logger = logger
  end

  def crawl!
    logger.info "Starting crawl of #{@start}"
    Page.create(url: @start)
    while page = next_uncrawled_page
      crawl_page page.url
    end
  end

  def next_uncrawled_page
    Page.detect do |page|
      page.links.nil?
    end
  end

  def crawl_page(url)
    uri = parse_url(url)
    logger.info uri.to_s

    page = parse_page(open(uri).read)
    page.url = uri.to_s
    page.save

    page[:links].each do |link|
      if Page.find(link).nil?
        Page.create(url: link)
      end
    end
  rescue OpenURI::HTTPError
    logger.warn "404: #{url}"
    Page.create(url: uri.to_s, links: [], assets: [], "404" => true)
  end

  def parse_page(html)
    doc = Nokogiri::HTML(html)

    css    = doc.css(%{link[type="text/css"]}).map{|node| node["href"]}.compact
    js     = doc.css(%{script}               ).map{|node| node["src"] }.compact
    images = doc.css(%{img}                  ).map{|node| node["src"] }.compact
    links  = doc.css(%{a}                    ).map{|node| node["href"]}.compact.map{|l|
      parse_url(l)
    }.compact.map(&:to_s).uniq.sort

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
  rescue URI::InvalidURIError
    logger.warn "Invalid URL: #{url}"
    return nil
  end
end

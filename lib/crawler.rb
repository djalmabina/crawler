require 'nokogiri'
require 'open-uri'
require 'logger'

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
    crawl_page @start
  end

  def crawl_page(url)
    logger.info "Crawling #{url}"
    uri = parse_url(url)

    if Page.find(uri.to_s)
      logger.info "Skipping duplicate #{uri.to_s}"
      return
    end

    page = parse_page(open(uri).read)
    page.url = uri.to_s

    page.save
    logger.info "Crawled #{page.inspect}"

    page[:links].each do |link|
      crawl_page link
    end
  end

  def parse_page(html)
    doc = Nokogiri::HTML(html)

    css    = doc.css(%{link[type="text/css"]}).map{|node| node["href"]}.compact
    js     = doc.css(%{script}               ).map{|node| node["src"] }.compact
    images = doc.css(%{img}                  ).map{|node| node["src"] }.compact
    links  = doc.css(%{a}                    ).map{|node| node["href"]}.compact.map{|l|
      parse_url(l)
    }.map(&:to_s).uniq.sort

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

  def log_file
  end
end

require 'bundler'
Bundler.require :test

require 'simplecov'
SimpleCov.minimum_coverage 100
SimpleCov.add_filter "vendor"
SimpleCov.start
require 'minitest/autorun'
require 'crawler'

class FakeSite
  def initialize(fixture_path)
  end

  def url
  end
end

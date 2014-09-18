require 'bundler'
Bundler.require :test

require 'simplecov'
SimpleCov.minimum_coverage 100
SimpleCov.add_filter "vendor"
SimpleCov.start
require 'minitest/autorun'
require 'crawler'
require 'webrick'

# Runs a directory as a webrick server on a locally accessible port (4000)
class FakeSite
  def initialize(fixture_path)
    @thread = Thread.new do
      Thread.abort_on_exception = true
      log_file = File.open("tmp/fake_server.log", "a")
      WEBrick::HTTPServer.new(
        Port: 4000,
        DocumentRoot: "test/fixtures/#{fixture_path}",
        AccessLog: [
          [log_file, WEBrick::AccessLog::COMMON_LOG_FORMAT]
        ],
        Logger: WEBrick::Log.new(log_file)
      ).start
    end

    # wait for boot
    loop do
      begin
        data = open(url)
        break
      rescue Errno::ECONNREFUSED
        sleep 0.001
      end
    end
  end

  def url
    "http://localhost:4000/"
  end

  def stop
    @thread.kill
  end
end

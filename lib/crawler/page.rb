require 'gdbm'
require 'json'

class Crawler::Page < Crawler::GDBMStore
  primary_key   :url
  database_file "pages.db"
end

class Crawler::GDBMStore < OpenStruct
  extend Enumerable

  def self.primary_key(key = nil)
    if key
      @primary_key = key
    else
      @primary_key
    end
  end

  def self.database_file(path)
    @db = GDBM.new(path)
    db.fastmode = true
  end

  def self.each
    db.each {|id, json| yield load(json) }
  end

  def self.find(query)
    data = db[query]
    return load(data) unless data.nil?
  end

  def self.create(attributes = {})
    new(attributes).save
  end

  def self.delete_all!
    db.clear
  end

  def self.to_a
    map do |record|
      record.to_h
    end
  end

  def save
    self.class.db[id] = dump
  end

  def id
    self.send self.class.primary_key
  end

  private
  def self.load(json)
    new(JSON.load(json))
  end

  def self.db
    @db
  end

  def dump
    JSON.dump(to_h)
  end
end

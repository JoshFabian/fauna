class ElasticIndex

  def self.create_all
    klasses.each do |klass|
      klass.__elasticsearch__.create_index!(force: true) rescue nil
    end
  end

  def self.delete_all
    klasses.each do |klass|
      klass.__elasticsearch__.delete_index! rescue nil
    end
  end

  # import all classes; use force: true to delete index first
  def self.import_all(options={})
    klasses.each do |klass|
      klass.import(options)
    end
  end

  def self.refresh_all
    klasses.each do |klass|
      klass.__elasticsearch__.refresh_index!
    end
  end

  protected

  def self.klasses
    [Category, Listing, Post, User, UserFollow]
  end
end
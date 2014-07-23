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

  def self.index_all
    klasses.each do |klass|
      klass.import
    end
  end

  def self.refresh_all
    klasses.each do |klass|
      klass.__elasticsearch__.refresh_index!
    end
  end

  protected

  def self.klasses
    [Category, Listing, Post]
  end
end
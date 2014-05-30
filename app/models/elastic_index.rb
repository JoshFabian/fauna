class ElasticIndex

  def self.create_all
    # klasses.each do |klass|
    #   # klass.create_elasticsearch_index rescue nil
    #   klass.__elasticsearch__.create_index! rescue nil
    # end
  end

  def self.delete_all
    # klasses.each do |klass|
    #   klass.index.delete rescue nil
    # end
  end

  def self.index_all
    klasses.each do |klass|
      klass.import
    end
  end

  protected

  def self.klasses
    [Category, Listing]
  end
end
class ElasticIndex

  def self.create_all
    # klasses.each do |klass|
    #   # klass.index.create rescue nil
    #   klass.create_elasticsearch_index rescue nil
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
    [Listing]
  end
end
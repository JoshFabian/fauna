class Story

  # search across multiple models
  def self.search(query_or_payload, models=[], options={})
    models = ::Elasticsearch::Model::StoryModel.new(models)
    search = ::Elasticsearch::Model::Searching::SearchRequest.new(models, query_or_payload, options)
    ::Elasticsearch::Model::Response::Response.new(models, search)
  end

end
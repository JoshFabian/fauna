class Story
  include Loggy

  def self.by_user(user, options={})
    user_id = user.respond_to?(:id) ? user.id : user
    query = {filter: {term: {user_id: user_id}}, sort: {created_at: "desc"}}
    search(query)
  end

  # search across multiple models
  def self.search(query_or_payload, models=[], options={})
    models = default_models if models.empty?
    models = ::Elasticsearch::Model::StoryModel.new(models)
    search = ::Elasticsearch::Model::Searching::SearchRequest.new(models, query_or_payload, options)
    ::Elasticsearch::Model::Response::Response.new(models, search)
  end

  protected
  
  def self.default_models
    [Listing]
  end
end
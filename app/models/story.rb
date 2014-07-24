class Story
  include Loggy

  def self.by_wall(user, options={})
    user_id = user.respond_to?(:id) ? user.id : user
    terms = [filter_wall(user_id), filter_active]
    query = {filter: {bool: {must: terms}}, sort: {created_at: "desc"}}
    search(query, options[:models])
  end

  # search across multiple models
  def self.search(query_or_payload, models=[], options={})
    models = default_models if models.blank?
    models = ::Elasticsearch::Model::StoryModel.new(models)
    search = ::Elasticsearch::Model::Searching::SearchRequest.new(models, query_or_payload, options)
    ::Elasticsearch::Model::Response::Response.new(models, search)
  end

  def self.filter_active
    ListingFilter.state('active')
  end

  def self.filter_wall(user_id)
    {term: {wall_id: user_id}}
  end

  protected

  def self.default_models
    [Listing, Post]
  end
end
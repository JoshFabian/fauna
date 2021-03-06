class PostShare
  include Loggy

  # returns true if the post should be shared and user has authorized share permissions
  def self.facebook_share_approved?(post, options={})
    !facebook_shared?(post, options) and post.facebook_share == 1 and facebook_shareable?(post, options)
  end

  # returns true if the post should be shared but requires permissions from the specified user
  def self.facebook_share_permissions_required?(post, options={})
    !facebook_shared?(post, options) and post.facebook_share == 1 and !facebook_shareable?(post, options)
  end

  # returns true if the post can be shared by the specified user
  def self.facebook_shareable?(post, options={})
    user = options[:by] || post.user
    user.facebook_share_permission?
  rescue Exception => e
    false
  end

  # returns true if the post has been shared by the owner
  def self.facebook_shared?(post, options={})
    post.facebook_shared?
  end

  # returns true or exception
  def self.facebook_share!(post, options={})
    user = options[:by] || post.user
    graph = Koala::Facebook::API.new(user.facebook_oauth.oauth_token)
    message = options[:message] || post.body
    link = options[:link] || "#{Settings[Rails.env][:api_host]}/#{user.handle}"
    result = graph.put_connections('me', 'feed', message: message, link: link)
    post.update(facebook_share_id: result['id'])
    # track event
    SegmentPost.track_post_share(post)
    true
  # rescue => e
    # if e.is_a?(Koala::Facebook::ClientError) and e.fb_error_type == "OAuthException"
    #   # invalid permissions
    # end
  end
end
class SegmentPost
  include Loggy

  # track events

  def self.track_post_create(post)
    raise Exception, "test environment" if Rails.env.test?
    hash = {user_id: post.user_id, event: 'Post Created', properties: {category: 'Story'}}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  def self.track_post_share(post, options={})
    raise Exception, "test environment" if Rails.env.test?
    hash = {user_id: post.user_id, event: 'Post Shared', properties: {category: 'Story', label: 'Facebook'}}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

end
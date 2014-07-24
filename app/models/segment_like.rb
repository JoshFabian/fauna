class SegmentLike
  include Loggy

  # track events

  def self.track_listing_like(like, options={})
    raise Exception, "test environment" if Rails.env.test?
    hash = {user_id: like.user_id, event: 'Listing Liked', properties: {category: 'Story'}}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  def self.track_post_like(like, options={})
    raise Exception, "test environment" if Rails.env.test?
    hash = {user_id: like.user_id, event: 'Post Liked', properties: {category: 'Story'}}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

end
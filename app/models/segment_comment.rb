class SegmentComment
  include Loggy

  # track events

  def self.track_comment_create(comment)
    raise Exception, "test environment" if Rails.env.test?
    hash = {user_id: comment.user_id, event: 'Comment Created', properties: {category: 'Story'}}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

end
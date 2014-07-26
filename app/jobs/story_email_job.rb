class StoryEmailJob
  include Backburner::Queue
  include Loggy
  queue "emails"  # defaults to 'backburner-jobs' tube
  queue_priority 1000 # most urgent priority is 0
  queue_respond_timeout 100 # number of seconds before job times out

  def self.perform(hash)
    if hash['type'] == 'comment'
      comment = Comment.find_by_id(hash['id'].to_i)
      return 0 if comment.blank? or comment.email_sent?
      if comment.commentable.is_a?(Post)
        # send post comment email
        StoryMailer.user_post_comment_email(comment).deliver
      end
      if comment.commentable.is_a?(Listing)
        # send list comment email
        StoryMailer.user_listing_comment_email(comment).deliver
      end
      # mark email sent flag
      comment.update(email_sent: 1)
      return 1
    else
      raise Exception, "invalid type"
    end
  rescue Exception => e
    logger.post("tegu.job", log_data.merge({event: 'story_email', error: e.message}))
    0
  end

end
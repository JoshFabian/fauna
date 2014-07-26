class CommentObserver < ActiveRecord::Observer
  include Loggy

  def after_create(comment)
    if !comment.email_sent? and (comment.commentable.is_a?(Listing) or comment.commentable.is_a?(Post))
      if comment.commentable.is_a?(Post)
        # send post comment email
        StoryMailer.user_post_comment_email(comment).deliver
      end
      if comment.commentable.is_a?(Listing)
        # send list comment email
        StoryMailer.user_listing_comment_email(comment).deliver
      end
    end
    # track comment
    SegmentComment.track_comment_create(comment)
  rescue Exception => e
  end

end
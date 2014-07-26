class CommentObserver < ActiveRecord::Observer
  include Loggy

  def after_create(comment)
    if comment.commentable.is_a?(Post) and !comment.email_sent?
      # send post comment email
      StoryMailer.user_post_comment_email(comment).deliver
    end
    # track comment
    SegmentComment.track_comment_create(comment)
  rescue Exception => e
  end

end
class CommentObserver < ActiveRecord::Observer
  include Loggy

  def after_create(comment)
    increment_wall_counter(comment)
    if comment.notify? and !comment.email_sent? and feature(:backburner_emails)
      # queue email
      Backburner::Worker.enqueue(StoryEmailJob, [{type: 'comment', id: comment.id}], delay: 1.minute)
    end
    # track event using segment io
    SegmentComment.track_comment_create(comment)
  rescue Exception => e
  end

  protected

  def increment_wall_counter(comment)
    user = comment.commentable.user
    raise Exception, "ignored" if user == comment.user
    user.increment!(:wall_comments_count)
  rescue Exception => e
  end

end
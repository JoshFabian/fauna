class CommentObserver < ActiveRecord::Observer
  include Loggy

  def after_create(comment)
    # track comment
    SegmentComment.track_comment_create(comment)
  rescue Exception => e
  end

end
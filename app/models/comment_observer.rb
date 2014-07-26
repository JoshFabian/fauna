class CommentObserver < ActiveRecord::Observer
  include Loggy

  def after_create(comment)
    if comment.notify? and !comment.email_sent?
      # queue email
      Backburner::Worker.enqueue(StoryEmailJob, Hashie::Mash.new(type: 'comment', id: comment.id), delay: 1.minute)
    end
    # track comment
    SegmentComment.track_comment_create(comment)
  rescue Exception => e
  end

end
class PostObserver < ActiveRecord::Observer
  include Loggy

  def after_create(post)
    if PostShare.facebook_share_approved?(post) and feature(:backburner)
      # queue share
      Backburner::Worker.enqueue(FacebookShareJob, [{id: post.id, klass: 'post'}])
    end
    # track post
    SegmentPost.track_post_create(post)
  rescue Exception => e
  end

  def after_save(post)
    post.__elasticsearch__.update_document
  rescue Exception => e
  end

  def after_destroy(post)
    post.__elasticsearch__.delete_document
  rescue Exception => e
  end

end
class LikeObserver < ActiveRecord::Observer
  observe ListingLike, PostLike
  include Loggy

  def after_create(object)
    # increment user wall counter
    increment_wall_counter(object)
    # track events using segment io
    if object.is_a?(ListingLike)
      SegmentLike.track_listing_like(object)
    elsif object.is_a?(PostLike)
      SegmentLike.track_post_like(object)
    end
  rescue Exception => e
  end

  protected

  def increment_wall_counter(object)
    if object.is_a?(ListingLike)
      user = object.listing.user
      user.increment!(:wall_likes_count)
    elsif object.is_a?(PostLike)
      user = object.post.user
      user.increment!(:wall_likes_count)
    end
  rescue Exception => e
  end
end
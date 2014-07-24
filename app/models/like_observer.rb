class LikeObserver < ActiveRecord::Observer
  observe ListingLike, PostLike
  include Loggy

  def after_create(object)
    if object.is_a?(ListingLike)
      SegmentLike.track_listing_like(object)
    elsif object.is_a?(PostLike)
      SegmentLike.track_post_like(object)
    end
  rescue Exception => e
  end

end
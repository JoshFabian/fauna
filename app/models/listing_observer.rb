class ListingObserver < ActiveRecord::Observer
  include Loggy

  def after_create(listing)
    # update user listing credits
    user = listing.user
    user.decrement!(:listing_credits, 1)
    # track listing
    SegmentListing.track_listing_created(listing)
  rescue Exception => e
  end

  def after_save(listing)
    if listing.sold?
      listing.__elasticsearch__.delete_document
    else
      listing.__elasticsearch__.update_document
    end
  rescue Exception => e
  end

  def after_destroy(listing)
    listing.__elasticsearch__.delete_document
  rescue Exception => e
  end
end
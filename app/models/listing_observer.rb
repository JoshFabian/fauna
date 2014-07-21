class ListingObserver < ActiveRecord::Observer
  include Loggy

  def after_create(listing)
    user = listing.user
    # update user listing credits
    user.decrement!(:listing_credits, 1) if user.listing_credits > 0
    if !user.roles?(:seller)
      # add user seller role
      user.roles << :seller
      user.save
    end
    # track listing
    SegmentListing.track_listing_create(listing)
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
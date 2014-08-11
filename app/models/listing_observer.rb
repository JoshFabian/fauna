class ListingObserver < ActiveRecord::Observer
  include Loggy

  def after_create(listing)
    user = listing.user
    # update user listing credits
    user.decrement!(:listing_credits, 1) if user.listing_credits > 0
    # update user facebook_share_listing state
    user.facebook_share_listing = listing.facebook_share
    # add user seller role if missing
    user.roles << :seller if !user.roles?(:seller)
    user.save
    # track listing
    SegmentListing.track_listing_create(listing)
  rescue Exception => e
  end

  def after_save(listing)
    if listing.state_changed? and ListingShare.facebook_share_approved?(listing) and feature(:backburner)
      # listing is active and facebook share has been approved
      Backburner::Worker.enqueue(FacebookShareJob, [{id: listing.id, klass: 'listing'}], delay: 30.seconds)
    end
    if listing.state_changed? and listing.flagged? and feature(:backburner_emails)
      # listing was flagged; queue email
      Backburner::Worker.enqueue(ListingFlaggedEmailJob, [{id: listing.id}], delay: 1.minute)
    end
    # check user store flag
    should_check_user_store(listing.user)
    # update search index
    listing.__elasticsearch__.update_document
  rescue Exception => e
  end

  def after_destroy(listing)
    # update search index
    listing.__elasticsearch__.delete_document
  rescue Exception => e
  end

  protected

  # check user store flag based on listings count
  def should_check_user_store(user)
    if !user.store? and user.should_be_store?
      user.update(store: true)
    else
      # noop
    end
  rescue Exception => e
  end

end
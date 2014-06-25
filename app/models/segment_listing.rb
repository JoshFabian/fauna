class SegmentListing
  include Loggy

  # track events

  def self.track_listing_created(listing)
    raise Exception, "test environment" if Rails.env.test?
    result = track(user_id: listing.user_id, event: 'listing_created')
    logger.post("tegu.app", log_data.merge({event: 'segmentio.listing_created', listing_id: listing.id}))
    result
  rescue Exception => e
    false
  end

  protected

  def self.track(hash)
    Analytics.track(hash)
  end
end
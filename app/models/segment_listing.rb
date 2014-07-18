class SegmentListing
  include Loggy

  # track events

  def self.track_listing_created(listing)
    raise Exception, "test environment" if Rails.env.test? or Rails.env.development?
    result = track(user_id: listing.user_id, event: 'listing_created')
    logger.post("tegu.app", log_data.merge({event: 'segmentio.listing_created', listing_id: listing.id}))
    result
  rescue Exception => e
    false
  end

  def self.track_listing_purchased(payment)
    raise Exception, "test environment" if Rails.env.test? or Rails.env.development?
    result = track(user_id: payment.buyer_id, event: 'listing_purchased')
    logger.post("tegu.app", log_data.merge({event: 'segmentio.listing_purchased', user_id: payment.buyer_id,
      listing_id: payment.listing_id}))
    result
  rescue Exception => e
    false
  end

  protected

  def self.track(hash)
    Analytics.track(hash)
  end
end
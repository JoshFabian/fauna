class SegmentListing
  include Loggy

  # track events

  def self.track_listing_created(listing)
    raise Exception, "test environment" if Rails.env.test?
    hash = {user_id: listing.user_id, event: 'Listing Created', properties: {category: 'Listing'}}
    result = track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  def self.track_listing_viewed(listing, options={})
    raise Exception, "test environment" if Rails.env.test?
    category = listing.categories.roots.first
    properties = {id: listing.id, sku: listing.id, name: listing.title, price: listing.price/100.0,
      category: 'Listing', label: category.try(:name)}
    user_id = options[:by].present? ? options[:by].id : 0
    hash = {user_id: user_id, event: 'Viewed Product', properties: properties}
    result = track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  end

  def self.track_listing_cart_add(listing, options={})
    raise Exception, "test environment" if Rails.env.test?
    category = listing.categories.roots.first
    properties = {id: listing.id, sku: listing.id, name: listing.title, price: listing.price/100.0, quantity: 1,
      category: 'Listing', label: category.try(:name)}
    user_id = options[:by].present? ? options[:by].id : 0
    hash = {user_id: user_id, event: 'Added Product', properties: properties}
    result = track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  end

  def self.track_listing_cart_remove(listing, options={})
    raise Exception, "test environment" if Rails.env.test?
    category = listing.categories.roots.first
    properties = {id: listing.id, sku: listing.id, name: listing.title, price: listing.price/100.0, quantity: 1,
      category: 'Listing', label: category.try(:name)}
    user_id = options[:by].present? ? options[:by].id : 0
    hash = {user_id: user_id, event: 'Removed Product', properties: properties}
    result = track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  end

  def self.track_listing_purchased(payment)
    raise Exception, "test environment" if Rails.env.test?
    listing = payment.listing
    revenue = payment.listing_price/100.0
    shipping = payment.shipping_price/100.0
    total = (payment.listing_price+payment.shipping_price)/100.0
    product = {id: listing.id, sku: listing.id, name: listing.title, price: revenue, quantity: 1}
    properties = {id: listing.id, category: 'Listing', total: total, revenue: revenue, shipping: shipping,
      tax: 0, products: {"0" => product}}
    # temporary event until 'Completed Order' is working
    hash = {user_id: payment.buyer_id, event: 'Purchased Product', properties: properties}
    result = track(hash)
    # todo: completed order doesn't seem to work
    hash = {user_id: payment.buyer_id, event: 'Completed Order', properties: properties}
    result = track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  protected

  def self.track(hash)
    Analytics.track(hash)
  end
end
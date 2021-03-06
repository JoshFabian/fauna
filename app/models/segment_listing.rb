class SegmentListing
  include Loggy

  # track events

  def self.track_listing_create(listing)
    raise Exception, "test environment" if Rails.env.test?
    category = listing.categories.roots.first
    hash = {user_id: listing.user_id, event: 'Listing Created', properties: {category: 'Listing',
      label: category.try(:name)}}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  def self.track_listing_remove(listing)
    raise Exception, "test environment" if Rails.env.test?
    category = listing.categories.roots.first
    hash = {user_id: listing.user_id, event: 'Listing Removed', properties: {category: 'Listing',
      label: category.try(:name)}}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  def self.track_category_view(category, options={})
    raise Exception, "test environment" if Rails.env.test?
    user_id = options[:by].present? ? options[:by].id : 0
    hash = {user_id: user_id, event: 'Viewed Category', properties: {id: category.id, category: 'Listing',
      label: category.try(:name)}}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  def self.track_listing_share(listing)
    raise Exception, "test environment" if Rails.env.test?
    hash = {user_id: listing.user_id, event: 'Listing Shared', properties: {category: 'Story',
      label: 'Facebook'}}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  # def self.track_listing_peek(listing, options={})
  #   raise Exception, "test environment" if Rails.env.test?
  #   category = listing.categories.roots.first
  #   properties = {id: listing.id, sku: listing.id, name: listing.title, price: listing.price/100.0,
  #     category: 'Listing', label: category.try(:name)}
  #   user_id = options[:by].present? ? options[:by].id : 0
  #   hash = {user_id: user_id, event: 'Listing Peek', properties: properties}
  #   result = Analytics.track(hash)
  #   logger.post("tegu.app", log_data.merge(hash))
  #   result
  # rescue Exception => e
  #   false
  # end

  def self.track_listing_view(listing, options={})
    raise Exception, "test environment" if Rails.env.test?
    category = listing.categories.roots.first
    properties = {id: listing.id, sku: listing.id, name: listing.title, price: listing.price/100.0,
      category: 'Listing', label: category.try(:name)}
    user_id = options[:by].present? ? options[:by].id : 0
    hash = {user_id: user_id, event: 'Viewed Product', properties: properties}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  def self.track_listing_cart_add(listing, options={})
    raise Exception, "test environment" if Rails.env.test?
    category = listing.categories.roots.first
    properties = {id: listing.id, sku: listing.id, name: listing.title, price: listing.price/100.0, quantity: 1,
      category: 'Listing', label: category.try(:name)}
    user_id = options[:by].present? ? options[:by].id : 0
    hash = {user_id: user_id, event: 'Added Product', properties: properties}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  def self.track_listing_cart_remove(listing, options={})
    raise Exception, "test environment" if Rails.env.test?
    category = listing.categories.roots.first
    properties = {id: listing.id, sku: listing.id, name: listing.title, price: listing.price/100.0, quantity: 1,
      category: 'Listing', label: category.try(:name)}
    user_id = options[:by].present? ? options[:by].id : 0
    hash = {user_id: user_id, event: 'Removed Product', properties: properties}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  def self.track_listing_purchase(payment)
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
    result = Analytics.track(hash)
    # todo: completed order doesn't seem to work
    hash = {user_id: payment.buyer_id, event: 'Completed Order', properties: properties}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

end
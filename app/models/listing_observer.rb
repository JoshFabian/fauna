class ListingObserver < ActiveRecord::Observer
  include Loggy

  def after_save(object)
  rescue Exception => e
  end

  def self.after_category_update(listing)
    listing.index!
  rescue Exception => e
  end
end
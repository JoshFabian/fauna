class ListingCategoryObserver < ActiveRecord::Observer
  include Loggy

  # def after_create(object)
  # rescue Exception => e
  # end

  def after_save(object)
    # puts "saved: #{object.inspect}, changes:#{object.changes}"
    category = object.category
    listing = object.listing
    # update category counter
    category.update_attributes(listings_count: category.listing_categories.count)
    # update search index
    listing.__elasticsearch__.update_document
  rescue Exception => e
  end

  # def after_update(object)
  # end

  def after_destroy(object)
    category = object.category
    listing = object.listing
    # update category counter
    category.update_attributes(listings_count: category.listing_categories.count)
    # update search index
    listing.__elasticsearch__.update_document
  end
end
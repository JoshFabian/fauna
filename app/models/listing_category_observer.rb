class ListingCategoryObserver < ActiveRecord::Observer

  # def after_create(object)
  # rescue Exception => e
  # end

  def after_save(object)
    # puts "saved: #{object.inspect}, changes:#{object.changes}"
    object.category.touch
    object.listing.touch
  rescue Exception => e
  end

  # def after_update(object)
  # end

  def after_destroy(object)
    object.category.touch
    object.listing.touch
  rescue Exception => e
  end
end
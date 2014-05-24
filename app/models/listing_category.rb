class ListingCategory < ActiveRecord::Base
  belongs_to :category
  belongs_to :listing

  validates :category, presence: true
  validates :listing, presence: true, uniqueness: {scope: :category}

  after_save :event_saved

  def event_saved
    ListingObserver.after_category_update(listing)
  end
end
class ListingCategory < ActiveRecord::Base
  belongs_to :category, touch: true
  belongs_to :listing, touch: true

  validates :category, presence: true
  validates :listing, presence: true, uniqueness: {scope: :category}
end
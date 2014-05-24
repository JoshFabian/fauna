class ListingCategory < ActiveRecord::Base
  belongs_to :category
  belongs_to :listing

  validates :category, presence: true
  validates :listing, presence: true, uniqueness: {scope: :category}
end
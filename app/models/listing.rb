class Listing < ActiveRecord::Base
  include AASM
  include Currency
  include Loggy
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :price, presence: true
  validates :state, presence: true
  validates :title, presence: true, uniqueness: {scope: :user}
  validates :user, presence: true

  has_many :images, class_name: "ListingImage", dependent: :destroy

  has_many :listing_categories, dependent: :destroy
  has_many :categories, through: :listing_categories

  belongs_to :user

  aasm column: 'state' do
    state :approved, initial: true
  end

  def primary_image
    images.order("position asc").first
  end

  def price=(s)
    write_attribute(:price, to_cents(s))
  end
end
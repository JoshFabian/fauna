class Listing < ActiveRecord::Base
  include AASM
  include Currency
  include Elasticsearch::Model
  include FriendlyId
  include Loggy

  validates :price, presence: true
  validates :state, presence: true
  validates :title, presence: true, uniqueness: {scope: :user}
  validates :user, presence: true

  has_many :images, class_name: "ListingImage", dependent: :destroy

  has_many :listing_categories, dependent: :destroy
  has_many :categories, through: :listing_categories

  belongs_to :user

  # friendly_id :title, use: :slugged
  friendly_id :title, use: :scoped, scope: :user

  aasm column: 'state' do
    state :approved, initial: true
    state :sold

    event :sold do
      transitions to: :sold, :from => [:approved]
    end
  end

  # mappings do
  #   indexes :category_names, analyzer: 'snowball'
  # end

  # set search index name
  index_name "listings.#{Rails.env}"

  def as_indexed_json(options={})
    as_json(methods: [:category_ids, :category_names, :user_handle])
  end

  def category_ids
    categories.collect(&:id)
  end

  def category_names
    categories.collect{ |o| o.name.downcase }
  end

  def price=(s)
    write_attribute(:price, to_cents(s))
  end

  def primary_image
    images.order("position asc").first
  end

  # used by friendly_id
  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def user_handle
    user.try(:handle)
  end
end
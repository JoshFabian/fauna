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
  has_many :payments, dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_many :listing_categories, dependent: :destroy
  has_many :categories, through: :listing_categories

  belongs_to :user

  serialize :shipping_prices, Hash

  store :data, accessors: [:shipping_from, :shipping_time, :local_pickup]

  attr_accessor :shipping_to

  friendly_id :title, use: :scoped, scope: :user

  aasm column: 'state' do
    state :approved, initial: true
    state :sold

    event :sold do
      transitions to: :sold, :from => [:approved, :sold]
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

  def editable?
    approved? and (self.created_at > 3.days.ago)
  end

  def price=(s)
    write_attribute(:price, to_cents(s))
  end

  def primary_image
    images.order("position asc").first
  end

  def purchased_by?(user)
    payments.completed.where(buyer_id: user.id).exists?
  rescue Exception => e
    false
  end

  def review_allowed?(user)
    payments.completed.where(buyer_id: user.id).where("completed_at <= ?", 24.hours.ago).exists?
  rescue Exception => e
    false
  end

  def reviewed_by?(user)
    reviews.where(user_id: user.id).exists?
  rescue Exception => e
    false
  end

  def shipping_price(options)
    return 0 if options[:to].to_s.match(/local/)
    raise Exception, "invalid location" if shipping_prices[options[:to]].blank?
    (shipping_prices[options[:to]].to_f * 100).to_i
  end

  # used by friendly_id
  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def user_handle
    user.try(:handle)
  end
end
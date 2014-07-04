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
  has_many :reports, class_name: "ListingReport", dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_many :listing_categories, dependent: :destroy
  has_many :categories, through: :listing_categories

  belongs_to :user

  serialize :shipping_prices, Hash

  store :data, accessors: [:shipping_from, :shipping_time]

  attr_accessor :shipping_to

  friendly_id :title, use: :scoped, scope: :user

  aasm column: 'state' do
    state :active, initial: true
    state :sold, enter: :event_state_sold

    event :sold do
      transitions to: :sold, :from => [:active, :sold]
    end
  end

  # mappings do
  #   indexes :category_names, analyzer: 'snowball'
  # end

  # set search index name
  index_name "listings.#{Rails.env}"

  before_validation(on: :create) do
    if user.present? and !user.sellable?
      self.errors[:base].push("not allowed")
    end
  end

  def as_indexed_json(options={})
    as_json(methods: [:category_ids, :category_names, :user_handle])
  end

  def as_json(options={})
    options ||= {}
    if options[:methods].blank?
      options[:methods] = [:category_ids]
    end
    super(options)
  end

  def category_ids
    categories.pluck(:id)
  end

  def category_names
    categories.collect{ |o| o.name.downcase }
  end

  def editable?
    active? and (self.created_at.blank? or self.created_at > 3.days.ago)
  end

  def event_state_sold
    self.sold_at = Time.zone.now
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
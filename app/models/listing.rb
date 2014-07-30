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

  belongs_to :user

  has_many :images, class_name: "ListingImage", dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :reports, class_name: "ListingReport", dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_many :listing_categories, dependent: :destroy
  has_many :categories, through: :listing_categories

  has_many :comments, as: :commentable
  has_many :likes, class_name: "ListingLike", dependent: :destroy

  serialize :shipping_prices, Hash

  store :data, accessors: [:facebook_share, :facebook_share_id, :flagged_reason, :shipping_from, :shipping_time]

  attr_accessor :shipping_to

  friendly_id :title, use: :scoped, scope: :user

  aasm column: 'state' do
    state :active, initial: true
    state :flagged, enter: :event_state_flagged
    state :removed, enter: :event_state_removed
    state :sold, enter: :event_state_sold

    event :flag do
      transitions to: :flagged, :from => [:active, :flagged]
    end

    event :remove do
      transitions to: :removed, :from => [:active, :removed]
    end

    event :report do
      transitions to: :reported, :from => [:active, :reported]
    end

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
    as_json(methods: [:category_ids, :category_names, :facebook_share, :facebook_share_id, :user_handle, :wall_id],
      except: [:data])
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

  def event_state_flagged
    self.flagged_at = Time.zone.now
  rescue Exception => e
  end

  def event_state_removed
    self.removed_at = Time.zone.now
  rescue Exception => e
  end

  def event_state_sold
    self.sold_at = Time.zone.now
  rescue Exception => e
  end

  def facebook_share
    self.data[:facebook_share].to_i
  end

  def facebook_shared?
    self.facebook_share_id.present?
  end

  def flag_with_reason!(options={})
    self.flagged_reason = options[:reason]
    self.flag!
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

  def should_update_index!
    self.__elasticsearch__.index_document rescue nil
  end

  def user_handle
    user.try(:handle)
  end

  def wall_id
    self.user_id
  end

end
class User < ActiveRecord::Base
  include FriendlyId
  include Loggy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,:lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  alias_attribute :auth_token, :authentication_token

  acts_as_mappable lat_column_name: :lat, lng_column_name: :lng, default_units: :miles

  validates :email, presence: true, uniqueness: true
  validates :handle, presence: true, uniqueness: {case_sensitive: false}, format: {with: /[a-z0-9]/}

  has_many :oauths, dependent: :destroy
  has_many :facebook_oauths, -> { where(provider: 'facebook') }, :class_name => 'Oauth'
  has_many :twitter_oauths, -> { where(provider: 'twitter') }, :class_name => 'Oauth'

  has_many :listings, dependent: :destroy
  has_many :payments, class_name: 'Payment', foreign_key: 'buyer_id', dependent: :destroy
  has_many :purchases, -> { where state: 'completed' }, class_name: 'Payment', foreign_key: 'buyer_id'

  has_one :avatar_image, class_name: 'UserAvatarImage', dependent: :destroy
  has_many :cover_images, class_name: 'UserCoverImage', dependent: :destroy

  has_many :phone_tokens

  has_many :charges, class_name: "PlanCharge", dependent: :destroy
  has_many :subscriptions, class_name: "PlanSubscription", dependent: :destroy

  has_many :authored_reviews, class_name: "Review", dependent: :destroy

  # following
  has_many :user_follows, dependent: :destroy
  has_many :following, through: :user_follows, source: :following

  # followers
  has_many :user_followers, class_name: "UserFollow", foreign_key: 'following_id', dependent: :destroy
  has_many :followers, through: :user_followers, source: :user

  # posts, comments
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  friendly_id :slug

  bitmask :roles, :as => [:admin, :basic, :buyer, :seller]

  store :data, accessors: [:facebook_share_listing, :facebook_share_post, :welcome_message]

  # private messaging
  acts_as_messageable

  before_validation(on: :create) do
    self.auth_token ||= generate_authentication_token
    self.handle ||= self.email
    self.roles = [:basic]
    self.trial_ends_at ||= 30.days.from_now
  end

  # def as_json(options={})
  #   options ||= {}
  #   options[:methods] = [] if options[:methods].blank?
  #   options[:methods] << :handle_lower if !options[:methods].include?(:handle_lower)
  #   super(options)
  # end

  def city_state
    [city, state_code].reject{|s| s.blank? }.compact.join(', ')
  end

  def city_state_zip
    [city_state, postal_code].join(' ')
  end

  def facebook_oauth
    facebook_oauths.last
  end

  def facebook_share_permission?
    facebook_oauth.facebook_share_permission?
  rescue Exception => e
    false
  end

  def facebook_verified?
    facebook_oauths.count > 0
  end

  def first_last_initial
    [first_name, last_name.first(1)].compact.join(' ') rescue ''
  end

  def full_name
    [first_name, last_name].compact.join(' ') rescue ''
  end

  def full_public_id
    "v#{self.version}/#{self.public_id}.#{self.format}"
  end

  # handle requires formatting
  def handle=(s)
    s = s.split('@')[0].gsub(/[^a-zA-Z0-9]/, '') rescue Faker::Number.number(5)
    # check for uniqueness
    1.upto(3) do |i|
      break if !User.where.not(id: self.id).exists?(handle: s)
      s = s + Faker::Number.number(3)
    end
    write_attribute(:handle, s)
    write_attribute(:slug, s.downcase)
  end

  def initials
    [first_name.first(1), last_name.first(1)].compact.join('') rescue ''
  end

  def listing_category_ids
    listings.includes(:categories).where("categories.level = 1").references(:categories).pluck("distinct category_id")
  end

  # reviews for user's listing
  def listing_reviews
    Review.where(listing_id: listings.select(:id).collect(&:id))
  end

  # ratings for user's listings
  def listing_ratings
    review_ids = Review.where(listing_id: listings.select(:id).collect(&:id)).select(&:id).collect(&:id)
    ReviewRating.where(review_id: review_ids)
  end

  def listing_average_ratings
    listing_ratings.group(:name).average(:rating)
  end

  # used by mailboxer to deliver message notifications
  def mailboxer_email(object)
    email
  end

  def paypal_verified?
    paypal_email.present?
  end

  def phone_number
    phone_tokens.verified.last.try(:to)
  end

  def phone_verified?
    phone_tokens.verified.count > 0
  end

  def profile_complete?
    self.about.present?
  end

  def sellable?
    trial? or listing_credits > 0 or (subscriptions_count > 0 and subscriptions.active.count > 0)
  end

  # returns true if the user store flag should be set
  def should_be_store?
    listings.where(state: ['active', 'draft', 'removed', 'sold']).count >= 10
  end

  # update inbox unread count
  def should_update_inbox_unread_count!
    i = mailbox.inbox.unread(self).pluck("distinct conversations.id").size
    update_attributes(inbox_unread_count: i) if i != inbox_unread_count
  end

  def trial?
    self.trial_ends_at.present? and self.trial_ends_at > Time.zone.now
  end

  def twitter_verified?
    twitter_oauths.count > 0
  end

  # return true if the user is both paypal and phone verified
  def verified?
    paypal_verified? and phone_verified?
  end

  # build user object from omniauth auth hash
  def self.from_omniauth(auth)
    User.new do |user|
      user.email = auth.info.email rescue ''
      user.handle = (auth.info.nickname || auth.info.name) rescue ''
    end
  end

  def self.by_slug(s, options={})
    user = User.where("slug = ?", s.to_s.downcase).first
    user = User.find_by_id(s) if s.to_s.match(/^\d+$/) and user.blank?
    user
  end

  def self.by_slug!(s, options={})
    user = by_slug(s, options)
    raise ::ActiveRecord::RecordNotFound if user.blank?
    user
  end

  protected

  def generate_authentication_token
    token = Devise.friendly_token
    # loop do
    #   token = Devise.friendly_token
    #   break token unless User.where(auth_token: token).first
    # end
  end

end
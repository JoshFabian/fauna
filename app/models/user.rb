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
  validates :handle, presence: true, uniqueness: true, format: {with: /[a-z0-9]/}

  has_many :oauths, dependent: :destroy
  has_many :facebook_oauths, -> { where(provider: 'facebook') }, :class_name => 'Oauth'

  has_many :listings, dependent: :destroy

  has_one :avatar_image, class_name: "UserAvatarImage", dependent: :destroy
  has_many :cover_images, class_name: "UserCoverImage", dependent: :destroy

  has_many :phone_tokens

  friendly_id :handle

  bitmask :roles, :as => [:admin, :basic]

  before_validation(on: :create) do
    self.auth_token ||= generate_authentication_token
    self.handle ||= self.email
    self.roles = [:basic]
  end

  def city_state
    [city, state_code].compact.join(', ')
  end

  def city_state_zip
    [city_state, postal_code].join(' ')
  end

  def email_verified?
    email.present?
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
  end

  def initials
    [first_name.first(1), last_name.first(1)].compact.join('') rescue ''
  end

  def phone_verified?
    phone_tokens.verified.count > 0
  end

  # build user object from omniauth auth hash
  def self.from_omniauth(auth)
    User.new do |user|
      user.email = auth.info.email
      user.handle = auth.info.nickname || auth.info.name
    end
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
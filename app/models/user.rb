class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,:lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  alias_attribute :auth_token, :authentication_token

  validates :email, presence: true, uniqueness: true
  validates :handle, presence: true, uniqueness: true

  has_many :oauths, dependent: :destroy
  has_many :facebook_oauths, -> { where(provider: 'facebook') }, :class_name => 'Oauth'

  bitmask :roles, :as => [:admin, :basic]

  before_validation(on: :create) do
    self.auth_token ||= generate_authentication_token
    self.handle ||= self.email
    self.roles = [:basic]
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
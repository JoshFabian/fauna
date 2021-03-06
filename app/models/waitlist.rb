class Waitlist < ActiveRecord::Base
  include Loggy

  validates :email, presence: true, uniqueness: true, email: true

  attr_accessor :prefix

  scope :both, -> { where(role: 'both') }
  scope :buyer, -> { where(role: 'buyer') }
  scope :seller, -> { where(role: 'seller') }

  before_validation(on: :create) do
    self.code ||= generate_token(prefix: self.prefix)
    self.role ||= 'both'
  end

  def share_url
    "http://www.fauna.net/landing/#{code}"
  end

  def as_json(options={})
    options ||= {}
    super(methods: [:share_url])
  end

  protected

  def generate_token(options={})
    token = Digest::SHA1.hexdigest([Time.now, rand].join)[8..16]
    token = options[:prefix].first(10) + token if options[:prefix].present?
    token
  end

end
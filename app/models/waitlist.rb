class Waitlist < ActiveRecord::Base
  include Loggy

  validates :email, presence: true, uniqueness: true, email: true

  attr_accessor :prefix

  before_validation(on: :create) do
    self.code ||= generate_token(prefix: self.prefix)
  end

  protected

  def generate_token(options={})
    token = Digest::SHA1.hexdigest([Time.now, rand].join)[8..16]
    token = options[:prefix].first(10) + token if options[:prefix].present?
    token
  end

end
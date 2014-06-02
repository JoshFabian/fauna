class PhoneToken < ActiveRecord::Base
  include AASM

  belongs_to :user

  validates :user, :presence => true

  attr_accessor :prefix

  aasm column: 'state' do
    state :created, initial: true
    state :sent, enter: :event_state_sent
    state :verified, enter: :event_state_verified

    event :sent do
      transitions to: :sent, :from => [:created]
    end

    event :verify do
      transitions to: :verified, :from => [:sent, :created]
    end
  end

  before_validation(on: :create) do
    self.code ||= generate_token(prefix: self.prefix)
  end

  def event_state_sent
    self.sent_at = Time.zone.now
  end

  def event_state_verified
    self.verified_at = Time.zone.now
  end

  def send_sms(options={})
    config = Settings[Rails.env]
    client = Twilio::REST::Client.new(config[:sid], config[:token])
    message = client.account.messages.create(from: config[:from], to: options[:to], body: options[:body])
    # update state
    self.sent!
    true
  rescue Exception => e
    false
  end

  protected

  def generate_token(options={})
    token = Digest::SHA1.hexdigest([Time.now, rand].join)[8..13]
    token = options[:prefix].first(3) + token if options[:prefix].present?
    token
  end

end
class Payment < ActiveRecord::Base
  include AASM

  validates :buyer, presence: true
  validates :listing, presence: true
  validates :listing_price, presence: true
  validates :shipping_price, presence: true
  validates :shipping_to, presence: true

  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :listing

  aasm column: 'state' do
    state :init, initial: true
    state :created
    state :completed, enter: :event_state_completed
    state :canceled, enter: :event_state_canceled
    state :exception, enter: :event_state_exception

    event :start do
      transitions to: :created, :from => [:created, :init]
    end

    event :cancel do
      transitions to: :canceled, :from => [:created, :init, :canceled]
    end

    event :error do
      transitions to: :exception, :from => [:created, :init]
    end

    event :complete do
      transitions to: :completed, :from => [:created, :init]
    end
  end

  def event_state_completed
    self.completed_at = Time.zone.now
  end

  def event_state_canceled
    self.canceled_at = Time.zone.now
  end

  def event_state_exception
  end

  # use paypal pay method to pay the seller
  def paypal_pay(options={})
    amount = ((listing.price+shipping_price)/100.0)
    seller = listing.user
    receiver_email = options[:seller_email].present? ? options[:seller_email] : seller.paypal_email
    mash = Hashie::Mash.new(
      actionType: "PAY",
      cancelUrl: options[:cancel_url],
      currencyCode: "USD",
      feesPayer: "SENDER",
      ipnNotificationUrl: options[:ipn_notify_url],
      receiverList: {
        receiver: [{amount: amount, email: receiver_email}]
      },
      returnUrl: options[:return_url],
    ).merge(options)
    # use adaptive payments pay method
    api = PayPal::SDK::AdaptivePayments.new
    response = api.pay(api.build_pay(mash))
    if response.success?
      # update payment state
      self.update(key: response.payKey, payment_url: api.payment_url(response))
      self.start!
    else
      self.update(error_message: response.error[0].message)
      self.error!
      raise Exception, self.error_message
    end
  end

  # get paypal payment details
  def paypal_details(options={})
    api = PayPal::SDK::AdaptivePayments.new
    mash = Hashie::Mash.new(payKey: key)
    response = api.payment_details(api.build_payment_details(mash))
    if response.success?
      # response contains all the payment details
      Hashie::Mash.new(response.to_hash)
    else
      # whoops
    end
  end
end
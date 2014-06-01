class Payment < ActiveRecord::Base
  include AASM

  validates :listing, presence: true
  validates :buyer, presence: true

  belongs_to :listing
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'

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
      transitions to: :canceled, :from => [:created, :init]
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

  def start(options={})
    amount = (listing.price/100.0)
    seller = listing.user
    receiver_email = options[:buyer_email].present? ? options[:buyer_email] : seller.email
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
    # build request object
    api = PayPal::SDK::AdaptivePayments.new
    pay = api.build_pay(mash)
    # make API call & get response
    response = api.pay(pay)
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
end
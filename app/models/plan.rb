class Plan < ActiveRecord::Base
  include AASM
  include Loggy

  has_many :subscriptions,class_name: "PlanSubscription",  dependent: :destroy
  has_many :charges, class_name: "PlanCharge", dependent: :destroy
  
  validates :amount, presence: true
  validates :interval, presence: true, inclusion: { in: %w(week month year) }, if: "subscription?"
  validates :interval_count, presence: true, if: "subscription?"
  validates :name, presence: true, uniqueness: true

  store :data, accessors: [:credits, :savings]

  scope :credit, -> { where(subscription: false) }
  scope :subscription, -> { where(subscription: true) }

  before_validation(on: :create) do
    if self.subscription? and self.interval_count.blank?
      self.interval_count = 1
    end
  end

  aasm column: 'state' do
    state :active, initial: true
    state :disabled
  end

  def currency
    'usd'
  end

  def stripe_id
    "plan:#{self.id}"
  end
end
class Plan < ActiveRecord::Base
  include AASM
  include Loggy

  validates :amount, presence: true
  validates :interval, presence: true, inclusion: { in: %w(week month year) }, if: "subscription?"
  validates :interval_count, presence: true, if: "subscription?"
  validates :name, presence: true, uniqueness: true

  store :data, accessors: [:credits]

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
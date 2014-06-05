class PlanCharge < ActiveRecord::Base
  include AASM
  include Loggy

  belongs_to :plan, counter_cache: :charges_count
  belongs_to :user, counter_cache: :charges_count

  store :data, accessors: [:stripe]

  validates :plan, presence: true
  validates :user, presence: true, uniqueness: {scope: :plan}

  delegate :amount, to: :plan

  aasm column: 'state' do
    state :charged, initial: true
    state :refunded

    event :refund do
      transitions to: :refunded, :from => [:charged]
    end
  end

  def as_json(options={})
    options ||= {}
    if options[:only].blank?
      options[:only] = [:id, :plan_id]
    end
    if options[:methods].blank?
      options[:methods] = [:stripe_id]
    end
    super(options)
  end

  def refund
    object = Stripe::Charge.retrieve('xxx')
    object.refund
    refund!
  rescue Exception => e
    puts e.message
    false
  end

  def stripe_id
    self.stripe['id']
  end
end
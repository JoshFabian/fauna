class Subscription < ActiveRecord::Base
  include AASM
  include Loggy

  belongs_to :plan, counter_cache: :subscriptions_count
  belongs_to :user, counter_cache: :subscriptions_count

  store :data, accessors: [:stripe]

  validates :plan, presence: true
  validates :user, presence: true, uniqueness: {scope: :plan}

  aasm column: 'state' do
    state :active, initial: true
    state :expired, enter: :event_state_expired

    event :expire do
      transitions to: :expired, :from => [:active, :expired]
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

  def event_state_expired
    
  end

  def stripe_id
    self.stripe['id']
  end
end
class Subscription < ActiveRecord::Base
  belongs_to :plan, counter_cache: :subscriptions_count
  belongs_to :user, counter_cache: :subscriptions_count

  store :data, accessors: [:stripe]

  validates :plan, presence: true
  validates :user, presence: true, uniqueness: {scope: :plan}

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

  def stripe_id
    self.stripe['id']
  end
end
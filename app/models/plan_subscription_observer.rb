class PlanSubscriptionObserver < ActiveRecord::Observer
  include Loggy

  def after_create(plan_subscription)
    # segment io events
    SegmentPlan.track_plan_subscription(plan_subscription)
  end

end
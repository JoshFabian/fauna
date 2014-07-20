class PlanChargeObserver < ActiveRecord::Observer
  include Loggy

  def after_create(plan_charge)
    # segment io events
    SegmentPlan.track_plan_charge(plan_charge)
  end
end
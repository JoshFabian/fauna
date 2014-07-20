class SegmentPlan
  include Loggy

  def self.track_plan_charge(plan_charge)
    raise Exception, "test environment" if Rails.env.test?
    plan = plan_charge.plan
    revenue = plan.amount/100.0
    hash = {user_id: plan_charge.user_id, event: 'Buy Credits', properties: {category: 'Plan', label: plan.name,
      revenue: revenue}}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

  def self.track_plan_subscription(plan_subscription)
    raise Exception, "test environment" if Rails.env.test?
    plan = plan_subscription.plan
    revenue = plan.amount/100.0
    hash = {user_id: plan_subscription.user_id, event: 'Buy Subscription', properties: {category: 'Plan', label: plan.name,
      revenue: revenue}}
    result = Analytics.track(hash)
    logger.post("tegu.app", log_data.merge(hash))
    result
  rescue Exception => e
    false
  end

end
class PlansController < ApplicationController

  before_filter :authenticate_user!

  def index
    @credit_plans = Plan.active.where(subscription: false).order("amount asc")
    @subscription_plans = Plan.active.where(subscription: true).order("interval asc")
  end

end

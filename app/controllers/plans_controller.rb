class PlansController < ApplicationController

  before_filter :authenticate_user!
  before_filter :admin_role_required!, only: [:manage]

  # GET /plans
  def index
    @credit_plans = Plan.active.where(subscription: false).order("amount asc")
    @subscription_plans = Plan.active.where(subscription: true).order("interval asc")
  end

  # GET /plans/manage
  def manage
    @plans = Plan.all.order("id desc")
  end

end

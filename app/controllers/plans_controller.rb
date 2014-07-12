class PlansController < ApplicationController

  before_filter :authenticate_user!
  before_filter :admin_role_required!, only: [:manage, :show]

  # GET /plans
  def index
    @credit_plans = Plan.active.where(subscription: false).order("amount asc")
    @subscription_plans = Plan.active.where(subscription: true).order("interval_count desc")
  end

  # GET /plans/manage
  def manage
    @plans = Plan.all.order("id desc")
  end

  # GET /plans/1
  def show
    @plan = Plan.find(params[:id])
    @objects = @plan.subscription ? @plan.subscriptions : @plan.charges
  end

  # GET /plans/1/details
  def details
    @plan = Plan.find(params[:id])

    respond_to do |format|
      format.js
    end
  end
end

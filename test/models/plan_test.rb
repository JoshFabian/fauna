require 'test_helper'

class PlanTest < ActiveSupport::TestCase

  describe "create" do
    it "should create with required non-subscription attributes" do
      @plan = Plan.create!(name: "name", amount: 100, subscription: false, credits: 1)
      @plan.credits.must_equal 1
    end

    it "should create with required subscription attributes" do
      @plan = Plan.create!(name: "name", amount: 100, subscription: true, interval: 'month')
      @plan.interval_count.must_equal 1
    end

    it "should create in active state" do
      @plan = Plan.create!(name: "name", amount: 100, subscription: false)
      @plan.state.must_equal 'active'
    end
  end

  describe "subscriptions" do
    before do
      @user = Fabricate(:user)
      @plan = Plan.create!(name: "name", amount: 5000, subscription: true, interval: 'month')
    end

    it "should create user subscription" do
      @sub = @user.subscriptions.create(plan: @plan)
      @user.reload
      @user.subscriptions_count.must_equal 1
      @user.subscriptions.must_equal [@sub]
      @user.plans.must_equal [@plan]
      @plan.reload
      @plan.subscriptions_count.must_equal 1
    end

    it "should create subscription with stripe data" do
      @hash = {'id' => "x_y_z", "plan" => "plan"}
      @sub = @user.subscriptions.create(plan: @plan, stripe: @hash)
      @sub.stripe.must_equal(@hash)
      @sub.stripe_id.must_equal 'x_y_z'
    end
  end
end

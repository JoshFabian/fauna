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

  describe "charges" do
    before do
      @user = Fabricate(:user)
      @plan = Plan.create!(name: "name", amount: 1000, subscription: false)
    end

    it "should create charge" do
      @charge = @user.charges.create(plan: @plan)
      @charge.state.must_equal 'charged'
      @charge.amount.must_equal 1000
      @user.reload
      @user.charges_count.must_equal 1
      @user.charges.must_equal [@charge]
      @plan.reload
      @plan.charges_count.must_equal 1
    end

    it "should refund charge" do
      flexmock(Stripe::Charge, retrieve: flexmock("object", refund: {}))
      @charge = @user.charges.create(plan: @plan)
      @charge.refund
      @charge.state.must_equal 'refunded'
    end
  end

  describe "subscriptions" do
    before do
      @user = Fabricate(:user)
      @plan = Plan.create!(name: "name", amount: 5000, subscription: true, interval: 'month')
    end

    it "should create subscription" do
      @sub = @user.subscriptions.create(plan: @plan)
      @sub.state.must_equal 'subscribed'
      @user.reload
      @user.subscriptions_count.must_equal 1
      @user.subscriptions.must_equal [@sub]
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

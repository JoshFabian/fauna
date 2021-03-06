require 'test_helper'

class StripeApiSpec < ActionDispatch::IntegrationTest
  before do
    @user = Fabricate(:user)
  end

  describe "buy credits" do
    it "should add credits when stripe card token is valid" do
      @user.listing_credits.must_equal 0
      plan = Plan.create!(name: "Buy 1 Credit", amount: 500, credits: 1, subscription: false)
      flexmock(Stripe::Charge, create: {id: 'stripe_id_123', amount: 500})
      put "/api/v1/stripe/buy/credits/#{plan.id}?card_token=123&token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body.must_include({'event' => 'buy'})
      body['user'].must_include({'id' => @user.id, 'listing_credits' => 1})
      body['user']['charge'].must_include({'plan_id' => plan.id, 'stripe_id' => 'stripe_id_123'})
      @user.reload
      @user.listing_credits.must_equal 1
    end
  end

  describe "refund charge" do
    it "refund charge amount" do
      plan = Plan.create!(name: "Buy 1 Credit", amount: 500, credits: 1, subscription: false)
      charge = @user.charges.create(plan: plan, stripe: {id: "id_123"})
      flexmock(Stripe::Charge, retrieve: flexmock("object", refund: {}))
      put "/api/v1/stripe/refund/#{charge.id}?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body.must_include({'event' => 'refund'})
      body['charge'].must_include({'id' => charge.id})
      charge.reload
      charge.state.must_equal 'refunded'
    end
  end

  describe "subscribe" do
    it "should subscribe to plan when stripe card token is valid" do
      stripe_subscriptions = flexmock(Stripe::Subscription, create: {id: 'stripe_sub_id'})
      stripe_customer = flexmock(Stripe::Customer, subscriptions: stripe_subscriptions)
      customer = flexmock(Customer, find_or_create: stripe_customer)
      plan = Plan.create!(name: "Monthly", amount: 5000, subscription: true, interval: 'month')
      put "/api/v1/stripe/subscribe/#{plan.id}?card_token=123&token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body.must_include({'event' => 'subscribe'})
      body['user'].must_include({'id' => @user.id})
      body['user']['subscription'].must_include({'id' => @user.subscriptions.first.id, 'plan_id' => plan.id,
        'stripe_id' => 'stripe_sub_id'})
    end

    it "should unsubscribe to plan" do
      stripe_subscription = flexmock(Stripe::Subscription, delete: true)
      stripe_subscriptions = flexmock(Stripe::Subscription, retrieve: stripe_subscription)
      stripe_customer = flexmock(Stripe::Customer, subscriptions: stripe_subscriptions)
      customer = flexmock(Customer, find_or_create: stripe_customer)
      plan = Plan.create!(name: "Monthly", amount: 5000, subscription: true, interval: 'month')
      sub = @user.subscriptions.create(plan: plan, stripe: {id: 'stripe_sub_id'})
      put "/api/v1/stripe/unsubscribe/#{plan.id}?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body.must_include({'event' => 'unsubscribe'})
      body['user'].must_include({'id' => @user.id})
      @user.reload
      @user.subscriptions_count.must_equal 0
      @user.subscriptions.must_equal []
    end
  end

  describe "webhooks" do
    it "should capture event" do
      post "/api/v1/stripe/webhook", {event: "some.event"}
      response.success?.must_equal true
    end
  end
end
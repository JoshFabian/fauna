require 'test_helper'

class PaymentApiSpec < ActionDispatch::IntegrationTest
  before do
    @user = Fabricate(:user, listing_credits: 3)
    @listing = @user.listings.create!(title: "Title", price: 100, state: 'active',
      shipping_prices: {'US' => '50', 'everywhere' => '100'})
  end

  describe "payment create" do
    it "should create payment" do
      payment = flexmock(Payment, create!: flexmock("object", id: 1, paypal_pay: {},
        payment_url: 'http://sandbox.paypal.com', state: 'created'))
      post "/api/v1/payments/#{@listing.id}/shipping/to/US?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['payment'].must_include({'id' => 1, 'state' => 'created', 'payment_url' => 'http://sandbox.paypal.com'})
    end
  end

  describe "payment status" do
    it "should complete payment and start conversation" do
      @buyer = Fabricate(:user)
      @mash = Hashie::Mash.new(buyer: @buyer, listing: @listing, listing_price: @listing.price, shipping_price: 1000,
        shipping_to: 'US')
      @payment = Payment.create!(@mash)
      @payment.conversation.must_equal nil
      get "/api/v1/payments/#{@payment.id}/paypal/success?token=#{@user.auth_token}"
      response.status.must_equal 301
      response.header['Location'].must_match /#{@buyer.handle}\/messages/
      @payment.reload
      @payment.state.must_equal 'completed'
      @payment.conversation.present?.must_equal true
    end
  end
end
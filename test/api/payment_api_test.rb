require 'test_helper'

class PaymentApiSpec < ActionDispatch::IntegrationTest
  describe "payment create" do
    before do
      @user = Fabricate(:user, listing_credits: 3)
      @listing = @user.listings.create!(title: "Title", price: 100, shipping_prices: {'US' => '50',
        'everywhere' => '100'})
    end

    it "should create payment" do
      payment = flexmock(Payment, create!: flexmock("object", id: 1, paypal_pay: {},
        payment_url: 'http://www.paypal.com', state: 'created'))
      post "/api/v1/payments/#{@listing.id}/shipping/to/US?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['payment'].must_include({'id' => 1, 'state' => 'created', 'payment_url' => 'http://www.paypal.com'})
    end
  end
end
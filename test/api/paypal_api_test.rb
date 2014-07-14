require 'test_helper'

class PaypalApiSpec < ActionDispatch::IntegrationTest
  before do
    @user = Fabricate(:user)
    @email = "seller@fauna.net"
  end

  describe "verify email" do
    it "should verify paypal email and set user's paypal email address" do
      @user.paypal_email.must_equal nil
      api_response = flexmock('response', success?: true)
      api = flexmock(PayPal::SDK::AdaptiveAccounts::API).new_instances.should_receive(
        build_get_verified_status: {}, get_verified_status: api_response)
      put "/api/v1/paypal/verify/email?email=#{@email}&first_name=joe&last_name=bloggs&token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body.must_include({'event' => 'verified'})
      @user.reload
      body['user'].must_include({'id' => @user.id, 'paypal_email' => @email})
    end
  end
end
require 'test_helper'

class SmsApiSpec < ActionDispatch::IntegrationTest
  before do
    @user = Fabricate(:user)
    @to = '3125551212'
  end

  describe "send sms token" do
    it "should send token to number" do
      messages = flexmock(create: true)
      account = flexmock(messages: messages)
      client = flexmock(Twilio::REST::Client).new_instances.should_receive(account: account)
      put "/api/v1/sms/token/send?to=#{@to}&token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body.must_include({'event' => 'sent'})
      @token = @user.phone_tokens.first
      body['token'].must_include({'to' => '3125551212', 'code' => @token.code, 'state' => 'sent'})
    end
  end

  describe "verify sms token" do
    it "should verify valid token" do
      @token = @user.phone_tokens.create!(to: @to)
      put "/api/v1/sms/token/verify?code=#{@token.code}&token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body.must_include({'event' => 'verified'})
    end

    it "should not verify invalid token" do
      @token = @user.phone_tokens.create!(to: @to)
      put "/api/v1/sms/token/verify?code=12345&token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body.must_include({'event' => 'error'})
    end
  end
end
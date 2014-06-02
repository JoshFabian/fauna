require 'test_helper'

class PhoneTokenTest < ActiveSupport::TestCase
  before do
    @user = Fabricate(:user)
  end

  describe "create" do
    it "should create with required attributes" do
      @token = @user.phone_tokens.create!
    end

    it "should auto create token" do
      @token = @user.phone_tokens.create!
      @token.code.present?.must_equal true
    end
  end

  describe "state machine" do
    it "should start in created state" do
      @token = @user.phone_tokens.create!
      @token.state.must_equal 'created'
    end

    it "should transition to sent state on deliver event" do
      @token = @user.phone_tokens.create!
      @token.sent!
      @token.state.must_equal 'sent'
      @token.sent_at.present?.must_equal true
    end

    it "should transition to verified state on verify event" do
      @token = @user.phone_tokens.create!
      @token.sent!
      @token.verify!
      @token.state.must_equal 'verified'
      @token.verified_at.present?.must_equal true
    end
  end
end
require 'test_helper'

class UserApiSpec < ActionDispatch::IntegrationTest
  describe "user verified" do
    before do
      @user = Fabricate(:user)
    end

    it "should return false when user is not verified" do
      get "/api/v1/users/#{@user.id}/verified?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body.must_include({'user' => {'id' => @user.id, 'verified' => false}})
    end

    it "should return true when user phone is verified" do
      flexmock(User, find: flexmock('user', 'phone_verified?' => true, 'id' => @user.id))
      get "/api/v1/users/#{@user.id}/verified/phone?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body.must_include({'user' => {'id' => @user.id, 'verified' => true}})
    end
  end
end
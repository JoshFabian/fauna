require 'test_helper'

class UserApiSpec < ActionDispatch::IntegrationTest
  describe "user get" do
    before do
      @user = Fabricate(:user, handle: "User1")
    end

    it "should get user json" do
      get "/api/v1/users/#{@user.id}?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['user'].must_include({'id' => @user.id, 'handle' => 'User1', 'slug' => 'user1'})
    end
  end

  describe "user follow" do
    before do
      @user = Fabricate(:user)
    end

    it "should get user following list" do
      @seller = Fabricate(:user)
      UserFollow.follow!(@user, @seller)
      get "/api/v1/users/#{@user.id}/following?token=#{@user.auth_token}"
      response.status.must_equal 200
      body = JSON.parse(response.body)
      body['user'].must_include({'id' => @user.id})
      body['user']['following'].must_include([{'id' => @seller.id, 'handle' => @seller.handle}])
    end

    it "should get user followers list" do
      @seller = Fabricate(:user)
      UserFollow.follow!(@user, @seller)
      get "/api/v1/users/#{@seller.id}/followers?token=#{@seller.auth_token}"
      response.status.must_equal 200
      body = JSON.parse(response.body)
      body['user'].must_include({'id' => @seller.id})
      body['user']['followers'].must_include([{'id' => @user.id, 'handle' => @user.handle}])
    end

    it "should get user follow state" do
      @seller = Fabricate(:user)
      UserFollow.follow!(@user, @seller)
      get "/api/v1/users/#{@user.id}/following/#{@seller.id}?token=#{@seller.auth_token}"
      response.status.must_equal 200
      body = JSON.parse(response.body)
      body['user'].must_include({'id' => @user.id})
      body['user']['following'].must_include([{'follow_id' => @seller.id, 'follow_state' => 'following'}])
      UserFollow.unfollow!(@user, @seller)
      get "/api/v1/users/#{@user.id}/following/#{@seller.id}?token=#{@seller.auth_token}"
      response.status.must_equal 200
      body = JSON.parse(response.body)
      body['user'].must_include({'id' => @user.id})
      body['user']['following'].must_include([{'follow_id' => @seller.id, 'follow_state' => 'not-following'}])
    end
  end

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

    it "should return true when user is paypal and phone verified" do
      flexmock(User, find: flexmock('user', 'verified?' => true, 'id' => @user.id))
      get "/api/v1/users/#{@user.id}/verified?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body.must_include({'user' => {'id' => @user.id, 'verified' => true}})
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
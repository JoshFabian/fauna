require 'test_helper'

class UserTest < ActiveSupport::TestCase
  it "should create user" do
    @user = User.create!(email: "user@gmail.com", password: "x", password_confirmation: "x")
  end

  describe "auth token" do
    it "should create token" do
      @user = Fabricate(:user, email: "sanjay@gmail.com")
      @user.auth_token.present?.must_equal true
    end
  end

  describe "handle" do
    it "should allow letter, digits" do
      @user = Fabricate(:user, email: "brian@gmail.com", handle: 'brian0')
      @user.handle.must_equal "brian0"
    end

    it "should not allow random characters" do
      @user = Fabricate(:user, email: "brian@gmail.com", handle: 'brian-*')
      @user.handle.must_equal "brian"
    end

    it "should initialize handle using email" do
      @user = Fabricate(:user, email: "brian@gmail.com")
      @user.handle.must_equal "brian"
      @user = Fabricate(:user, email: "brian.f@gmail.com")
      @user.handle.must_equal "brianf"
    end

    it "should set unique handle when its a duplicate" do
      @user = Fabricate(:user, email: "andrea@gmail.com")
      @user.handle.must_equal "andrea"
      @user = Fabricate(:user, email: "andrea.@gmail.com")
      @user.handle.must_match /andrea(\d+)/
    end

    it "should not change handle when updating user" do
      @user = Fabricate(:user, email: "brian@gmail.com", handle: 'brian')
      @user.handle = 'brian'
      @user.save
      @user.reload.handle.must_equal 'brian'
    end
  end

  describe "roles" do
    before do
      @user = Fabricate(:user, email: "user@gmail.com")
    end

    it "should initialize role to basic" do
      @user.reload
      @user.roles?(:basic).must_equal true
      @user.roles?(:admin).must_equal false
    end

    it "should add admin role" do
      @user.roles << :admin
      @user.save
      @user.reload.roles?(:admin).must_equal true
    end

    it "should remove admin role" do
      @user.roles << :admin
      @user.save
      @user.reload
      @user.roles = @user.roles - [:admin]
      @user.save
      @user.reload.roles?(:admin).must_equal false
    end
  end

  describe "avatar" do
    before do
      @user = Fabricate(:user, email: "user@gmail.com")
    end

    it "should create avatar image" do
      @avatar = @user.create_avatar_image!(public_id: 'general', version: '1', format: 'png', width: 1425, height: 372)
      @user.reload
      @user.avatar_image.must_equal @avatar
    end
  end
end
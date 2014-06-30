require 'test_helper'

class UserTest < ActiveSupport::TestCase
  it "should create user with required attributes" do
    @user = User.create!(email: "user#{rand(100)}@gmail.com", password: "x", password_confirmation: "x")
  end

  describe "user auth token" do
    it "should create token" do
      @user = Fabricate(:user, email: "sanjay@gmail.com")
      @user.auth_token.present?.must_equal true
    end
  end

  describe "user handle" do
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

  describe "user roles" do
    before do
      @user = Fabricate(:user)
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

  describe "user location" do
    before do
      @user = Fabricate(:user)
    end

    it "should display city and state" do
      @user.update_attributes(city: "Chicago", state_code: "IL")
      @user.city_state.must_equal 'Chicago, IL'
    end

    it "should display city when no state" do
      @user.update_attributes(city: "Chicago")
      @user.city_state.must_equal 'Chicago'
    end

    it "should display city, state, and zip" do
      @user.update_attributes(city: "Chicago", state_code: "IL", postal_code: "60610")
      @user.city_state_zip.must_equal 'Chicago, IL 60610'
    end
  end

  describe "user avatar image" do
    before do
      @user = Fabricate(:user)
    end

    it "should create avatar image" do
      @avatar = @user.create_avatar_image!(public_id: 'general', version: '1', format: 'png', width: 1425, height: 372)
      @user.reload
      @user.avatar_image.must_equal @avatar
    end
  end

  describe "user cover images" do
    before do
      @user = Fabricate(:user)
    end

    it "should create cover image" do
      @cover = @user.cover_images.create!(public_id: 'general', version: '1', format: 'png', width: 1425, height: 372)
      @user.reload
      @cover.position.must_equal 1
      @user.cover_images.must_equal [@cover]
    end

    it "should create cover image with position" do
      @cover = @user.cover_images.create!(public_id: 'general', version: '1', format: 'png', width: 1425, height: 372,
        position: 3)
      @user.reload
      @cover.position.must_equal 3
      @user.cover_images.must_equal [@cover]
    end
  end

  describe "user messages" do
    before do
      @user1 = Fabricate(:user, email: "user1@gmail.com")
      @user2 = Fabricate(:user, email: "user2@gmail.com")
    end

    it "should add message to user2 inbox" do
      @receipt1 = @user1.send_message(@user2, "body 1", "test 1")
      @user2.mailbox.conversations.collect(&:subject).must_equal ['test 1']
      @user2.mailbox.inbox.collect(&:subject).must_equal ['test 1']
      @conversation = @user2.mailbox.inbox.first
      @conversation.participants.count.must_equal 2
      @conversation.is_read?(@user1).must_equal true
      @conversation.is_read?(@user2).must_equal false
    end

    it "should mark conversation as read for user2" do
      @receipt1 = @user1.send_message(@user2, "body 1", "test 1")
      @conversation = @user1.mailbox.sentbox.first
      @conversation.is_read?(@user2).must_equal false
      @conversation.mark_as_read(@user2)
      @conversation.is_read?(@user2).must_equal true
    end

    it "should move message to user2 trash" do
      @receipt1 = @user1.send_message(@user2, "body 1", "test 1")
      @user2.mailbox.trash.count.must_equal 0
      @conversation = @user2.mailbox.inbox.first
      @conversation.move_to_trash(@user2)
      @user2.mailbox.trash.count.must_equal 1
    end

    it "should add message to user1 sent folder" do
      @receipt1 = @user1.send_message(@user2, "body 1", "test 1")
      @user1.mailbox.sentbox.count.must_equal 1
      @conversation = @user1.mailbox.sentbox.first
      @conversation.participants.count.must_equal 2
      @conversation.is_read?(@user1).must_equal true
      @conversation.is_read?(@user2).must_equal false
    end
  end
end
require 'test_helper'

class MessageApiSpec < ActionDispatch::IntegrationTest
  describe "conversation actions" do
    before do
      @user1 = Fabricate(:user)
      @user2 = Fabricate(:user)
    end

    it "should mark user2 inbox message as read" do
      @receipt1 = @user1.send_message(@user2, "body 1", "test 1")
      @c1 = @user2.mailbox.inbox.first
      @c1.is_read?(@user2).must_equal false
      put "/api/v1/conversations/#{@c1.id}/read?token=#{@user2.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['conversations'].must_include([{'id' => @c1.id, 'event' => 'read'}])
      @c1.is_read?(@user2).must_equal true
    end

    it "should move user2 inbox message to trash and mark as read" do
      @receipt1 = @user1.send_message(@user2, "body 1", "test 1")
      @c1 = @user2.mailbox.inbox.first
      put "/api/v1/conversations/#{@c1.id}/trash?token=#{@user2.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['conversations'].must_include([{'id' => @c1.id, 'event' => 'trashed'}])
      @user2.mailbox.inbox.count.must_equal 0
      @user2.mailbox.trash.count.must_equal 1
      @c1.is_read?(@user2).must_equal true
    end

    it "should move user2 trash message to inbox" do
      @receipt1 = @user1.send_message(@user2, "body 1", "test 1")
      @c1 = @user2.mailbox.inbox.first
      @c1.move_to_trash(@user2)
      @user2.mailbox.inbox.count.must_equal 0
      put "/api/v1/conversations/#{@c1.id}/untrash?token=#{@user2.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['conversations'].must_include([{'id' => @c1.id, 'event' => 'untrashed'}])
      @user2.mailbox.inbox.count.must_equal 1
      @user2.mailbox.trash.count.must_equal 0
    end
  end

  describe "conversation create" do
    before do
      @user1 = Fabricate(:user)
      @user2 = Fabricate(:user)
    end

    it "should create conversation from user1 to user2" do
      data = {message: {subject: "subject 1", body: "body 1"}}
      post "/api/v1/conversations/to/#{@user2.id}?token=#{@user1.auth_token}", data
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['receipt'].must_include({'mailbox_type' => 'sentbox', 'receiver_id' => @user1.id, 'receiver_type' => 'User'})
    end
  end

  describe "conversation reply" do
    before do
      @user1 = Fabricate(:user)
      @user2 = Fabricate(:user)
    end

    it "should reply to conversation from user1" do
      @receipt1 = @user1.send_message(@user2, "body 1", "test 1")
      @c1 = @receipt1.message.conversation
      data = {message: {body: "reply 1"}}
      post "/api/v1/conversations/#{@c1.id}/reply?token=#{@user2.auth_token}", data
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['receipt'].must_include({'mailbox_type' => 'sentbox', 'receiver_id' => @user2.id, 'receiver_type' => 'User'})
    end
  end
end
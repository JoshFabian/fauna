require 'test_helper'

class PostTest < ActiveSupport::TestCase
  before do
    @user = Fabricate(:user, listing_credits: 3)
  end

  describe "create" do
    it "should create with required attributes" do
      @post = @user.posts.create!(body: "body 1")
    end

    it "should default wall_id to user" do
      @post = @user.posts.create!(body: "body 1")
      @post.wall_id.must_equal @user.id
    end

    it "should increment user.posts_count" do
      @post = @user.posts.create!(body: "body 1")
      @user.reload
      @user.posts_count.must_equal 1
    end
  end

  describe "post comments" do
    before do
      @post = Fabricate(:post, user: @user)
    end

    it "should create comment" do
      @comment = @post.comments.create!(body: "body", user: @user)
    end

    it "should increment post.comments_count" do
      @comment = @post.comments.create!(body: "body", user: @user)
      @post.reload
      @post.comments_count.must_equal 1
    end
  end
end
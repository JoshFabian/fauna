require 'test_helper'

class PostApiSpec < ActionDispatch::IntegrationTest
  before do
    @user = Fabricate(:user)
  end

  describe "post create" do
    it "should create post" do
      data = {post: {body: "post 1"}}
      post "/api/v1/posts?token=#{@user.auth_token}", data
      response.success?.must_equal true
      body = JSON.parse(response.body)
      post = @user.posts.first
      body['post'].must_include({'id' => post.id, 'user_id' => @user.id})
    end
  end

  describe "post comment create" do
    before do
      @post = Fabricate(:post, user: @user)
    end

    it "should create post comment" do
      data = {comment: {body: "comment 1"}}
      post "/api/v1/posts/#{@post.id}/comments?token=#{@user.auth_token}", data
      response.success?.must_equal true
      body = JSON.parse(response.body)
      comment = @user.comments.first
      body['post'].must_include({'id' => @post.id})
      body['post']['comment'].must_include({'id' => comment.id})
    end
  end
end
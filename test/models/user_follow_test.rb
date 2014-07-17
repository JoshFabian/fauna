require "test_helper"

class UserFollowTest < ActiveSupport::TestCase
  before(:each) do
    @user = Fabricate(:user)
    @blogger = Fabricate(:user)
  end

  it "should add follower exactly onece" do
    @user.following.must_equal []
    @user.followers.must_equal []
    UserFollow.follow!(@user, @blogger).must_equal true
    @user.reload.following.must_equal [@blogger]
    @user.reload.followers.must_equal []
    @blogger.reload.following.must_equal []
    @blogger.reload.followers.must_equal [@user]
    @blogger.reload.followers_count.must_equal 1
    UserFollow.follow!(@user, @blogger).must_equal true
    @user.reload.following.must_equal [@blogger]
    @blogger.reload.followers.must_equal [@user]
    @blogger.reload.followers_count.must_equal 1
  end

  it "should remove follower" do
    UserFollow.follow!(@user, @blogger)
    @user.reload
    @blogger.reload
    UserFollow.unfollow!(@user, @blogger).must_equal true
    @user.reload.following.must_equal []
    @blogger.reload.followers.must_equal []
    @blogger.reload.followers_count.must_equal 0
  end
end

require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  before do
    @user = Fabricate(:user, listing_credits: 3)
  end

  describe "search by wall" do
    before do
      [Listing, Post].each do |klass|
        klass.delete_all
        klass.__elasticsearch__.create_index! force: true
      end
    end

    # it "should find no stories" do
    #   Listing.import(force: true)
    #   Post.import(force: true)
    #   @stories = Story.by_wall(@user)
    #   @stories.size.must_equal 0
    # end

    it "should find 1 follow story for the follower" do
      UserFollow.delete_all
      @follower = Fabricate(:user)
      UserFollow.follow!(@follower, @user).must_equal true
      UserFollow.import(force: true)
      UserFollow.__elasticsearch__.refresh_index!
      @stories = Story.by_wall(@follower, models: [UserFollow])
      @stories.size.must_equal 1
      @user_follow = UserFollow.first
      @stories.results.collect{ |o| [o.type, o.id.to_i] }.must_equal [['user_follow', @user_follow.id]]
    end

    it "should find 1 listing story" do
      @listing = Fabricate(:listing, user: @user, state: 'active')
      Listing.import(force: true)
      Listing.__elasticsearch__.refresh_index!
      @stories = Story.by_wall(@user, models: [Listing])
      @stories.size.must_equal 1
      @stories.results.collect{ |o| [o.type, o.id.to_i] }.must_equal [['listing', @listing.id]]
    end

    it "should find 1 post story" do
      @post = Fabricate(:post, user: @user)
      Post.import(force: true)
      Post.__elasticsearch__.refresh_index!
      @stories = Story.by_wall(@user, models: [Post])
      @stories.size.must_equal 1
      @stories.results.collect{ |o| [o.type, o.id.to_i] }.must_equal [['post', @post.id]]
    end
  end

end
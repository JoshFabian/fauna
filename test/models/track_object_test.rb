require 'test_helper'

class TrackObjectTest < ActiveSupport::TestCase
  before do
    TrackObject.flush
    @user = Fabricate(:user)
    @listing = Fabricate(:listing, user: @user)
  end

  describe "listings" do
    it "should increment listing view count using listing id" do
      @listing.views_count.must_equal 0
      TrackObject.listing_view!(@listing.id, by: @user).must_equal 1
      @listing.reload
      @listing.views_count.must_equal 1
    end

    it "should increment listing view count using listing object" do
      @listing.views_count.must_equal 0
      TrackObject.listing_view!(@listing, by: @user).must_equal 1
      @listing.reload
      @listing.views_count.must_equal 1
    end

    it "should not increment listing view count twice within x minutes" do
      TrackObject.listing_view!(@listing, by: @user).must_equal 1
      @listing.reload
      @listing.views_count.must_equal 1
      TrackObject.listing_view!(@listing, by: @user).must_equal 0
      @listing.reload
      @listing.views_count.must_equal 1
    end
  end

  describe "users" do
    it "should increment profile view count by another user" do
      @viewer = Fabricate(:user)
      @user.views_count.must_equal 0
      TrackObject.profile_view!(@user.id, by: @viewer).must_equal 1
      @user.reload
      @user.views_count.must_equal 1
    end

    it "should not increment profile view count by same user" do
      @user.views_count.must_equal 0
      TrackObject.profile_view!(@user.id, by: @user).must_equal 0
      @user.reload
      @user.views_count.must_equal 0
    end
  end
end
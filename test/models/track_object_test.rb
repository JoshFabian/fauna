require 'test_helper'

class TrackObjectTest < ActiveSupport::TestCase
  before do
    TrackObject.flush
    @user = Fabricate(:user)
    @listing = Fabricate(:user)
  end

  describe "listings" do
    it "should increment listing view count" do
      TrackObject.listing_view!(@listing.id, by: @user.id).must_equal 1
    end
  end

  describe "users" do
    it "should increment profile view count by another user" do
      TrackObject.profile_view!(@user.id, by: @user.id+1).must_equal 1
    end

    it "should not increment profile view count by same user" do
      TrackObject.profile_view!(@user.id, by: @user.id).must_equal 0
    end
  end
end
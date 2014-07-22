require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  before do
    @user = Fabricate(:user, listing_credits: 3)
  end

  describe "search by user" do
    it "should find no stories" do
      @stories = Story.by_user(@user)
      @stories.size.must_equal 0
    end

    it "should find 1 story" do
      @listing = Fabricate(:listing, user: @user)
      Listing.import
      Listing.__elasticsearch__.refresh_index!
      @stories = Story.by_user(@user)
      @stories.size.must_equal 1
      @stories.results.collect{ |o| [o.type, o.id.to_i] }.must_equal [['listing', @listing.id]]
    end
  end

end
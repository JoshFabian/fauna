require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  before do
    @user = Fabricate(:user)
    @listing = Fabricate(:listing, user: @user)
  end

  describe "create" do
    it "should create with required attributes" do
      @reviewer = Fabricate(:user)
      @review = @listing.reviews.create!(user: @reviewer, body: "body")
      @reviewer.authored_reviews.count.must_equal 1
      @user.listing_reviews.count.must_equal 1
    end

    it "should update review average rating when ratings are added or removed" do
      @review = @listing.reviews.create!(user: @user, body: "body")
      # add ratings
      [{name: 'Communication', rating: 1}, {name: 'Description', rating: 2}].each do |hash|
        @review.ratings.create!(hash)
      end
      @review.reload
      @review.ratings.count.must_equal 2
      @review.avg_rating.must_equal 1.5
      @review.stars.must_equal 2
      # remove rating
      @review.ratings.order("id asc").first.destroy
      @review.reload
      @review.ratings.count.must_equal 1
      @review.avg_rating.must_equal 2
      @review.stars.must_equal 2
    end
  end

  describe "listing review ratings" do
    before do
      @user = Fabricate(:user)
      @listing1 = Fabricate(:listing, user: @user)
      @listing2 = Fabricate(:listing, user: @user)
      @reviewer = Fabricate(:user)
    end

    it "should average review ratings" do
      @review1 = @listing1.reviews.create!(user: @user, body: "seller was kinda good")
      @review1.ratings.create(name: "Communication", rating: 2)
      @review1.ratings.create(name: "Description", rating: 2)
      @review2 = @listing2.reviews.create!(user: @user, body: "seller was pretty good")
      @review2.ratings.create(name: "Communication", rating: 3)
      @review2.ratings.create(name: "Description", rating: 3)
      @user.listing_average_ratings.must_equal({'Communication' => 2.5, 'Description' => 2.5})
    end
  end
end
require 'test_helper'

class ListingTest < ActiveSupport::TestCase
  describe "create" do
    before do
      @user = Fabricate(:user)
    end

    it "should create with required attributes" do
      @listing = @user.listings.create!(title: "Title", price: 100)
    end

    it "should start in approved state" do
      @listing = @user.listings.create!(title: "Title", price: 100)
      @listing.state.must_equal 'approved'
    end
  end

  describe "search" do
    before do
      @user = Fabricate(:user)
      @listing1 = @user.listings.create!(title: "Lizard", price: 100)
      @listing2 = @user.listings.create!(title: "Tegu", price: 100)
      Listing.import
    end

    describe "by title" do
      it "should find on exact title match" do
        @results = Listing.search 'lizard'
        @results.size.must_equal 1
        @results = Listing.search 'tegu'
        @results.size.must_equal 1
        @results = Listing.search 'tegu*'
        @results.size.must_equal 1
      end

      it "should find on substring title match" do
        @results = Listing.search 'liz*'
        @results.size.must_equal 1
      end

      it "should not find when title doesn't match" do
        @results = Listing.search 'reptile'
        @results.size.must_equal 0
      end
    end

    describe "by user" do
      it "should find when user matches" do
        @results = Listing.search(filter: {term: {user_id: @user.id}})
        @results.size.must_equal 2
      end

      it "should not find when invalid user" do
        @results = Listing.search(filter: {term: {user_id: 0}})
        @results.size.must_equal 0
      end
    end
  end
end
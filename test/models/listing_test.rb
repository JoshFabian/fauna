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

  describe "slug" do
    before do
      @user = Fabricate(:user)
    end

    it "should auto create slug from title" do
      @listing = @user.listings.create!(title: "Listing 1", price: 100)
      @listing.slug.must_equal 'listing-1'
    end

    it "should change slug when title is changed" do
      @listing = @user.listings.create!(title: "Listing 1", price: 100)
      @listing.update_attributes(title: "Tegu Lizard")
      @listing.reload
      @listing.slug.must_equal "tegu-lizard"
    end
  end

  describe "search" do
    before do
      @user = Fabricate(:user)
    end

    describe "by category" do
      before do
        @lizards = Category.create!(name: 'Lizards')
        @geckos = Category.create!(name: 'Geckos')
        @listing1 = @user.listings.create!(title: "Lizard", price: 100)
        @listing1.categories.push(@lizards)
        @listing1.categories.push(@geckos)
        @listing1.category_names.must_equal ['lizards', 'geckos']
        Listing.import
        Listing.__elasticsearch__.refresh_index!
      end

      it "should find on exact category match" do
        @results = Listing.search 'lizards'
        @results.size.must_equal 1
        @results = Listing.search(filter: {term: {category_names: 'lizards'}})
        @results.size.must_equal 1
      end

      it "should find on substring category match" do
        @results = Listing.search 'liz*'
        @results.size.must_equal 1
      end

      it "should find on exact subcategory match" do
        @results = Listing.search 'geckos'
        @results.size.must_equal 1
        @results = Listing.search(filter: {term: {category_names: 'geckos'}})
        @results.size.must_equal 1
      end

      it "should not find on invalid category" do
        @results = Listing.search 'bogus'
        @results.size.must_equal 0
        @results = Listing.search(filter: {term: {category_names: 'bogus'}})
        @results.size.must_equal 0
      end
    end

    describe "by title" do
      before do
        @listing1 = @user.listings.create!(title: "Lizard", price: 100)
        @listing2 = @user.listings.create!(title: "Tegu", price: 100)
        Listing.import
        Listing.__elasticsearch__.refresh_index!
      end

      it "should find on exact title match" do
        @results = Listing.search 'lizard'
        @results.size.must_equal 1
        @results = Listing.search 'tegu'
        @results.size.must_equal 1
      end

      it "should find on substring title match" do
        @results = Listing.search 'liz*'
        @results.size.must_equal 1
        @results = Listing.search 'tegu*'
        @results.size.must_equal 1
      end

      it "should not find when title doesn't match" do
        @results = Listing.search 'reptile'
        @results.size.must_equal 0
      end
    end

    describe "by user handle" do
      before do
        @listing1 = @user.listings.create!(title: "1", price: 100)
        @listing2 = @user.listings.create!(title: "2", price: 100)
        Listing.import
        Listing.__elasticsearch__.refresh_index!
      end

      it "should find on handle match" do
        skip "only works with sleep"
        @results = Listing.search(@user.handle)
        @results.size.must_equal 2
        @results = Listing.search(filter: {term: {user_handle: @user.handle}})
        @results.size.must_equal 2
      end

      it "should not find when invalid handle" do
        @results = Listing.search(filter: {term: {user_handle: "bogus"}})
        @results.size.must_equal 0
      end
    end

    describe "by user id" do
      before do
        @listing1 = @user.listings.create!(title: "1", price: 100)
        @listing2 = @user.listings.create!(title: "2", price: 100)
        Listing.import
        Listing.__elasticsearch__.refresh_index!
      end

      it "should find on id match" do
        @results = Listing.search(filter: {term: {user_id: @user.id}})
        @results.size.must_equal 2
      end

      it "should not find when invalid id" do
        @results = Listing.search(filter: {term: {user_id: 0}})
        @results.size.must_equal 0
      end
    end
  end
end
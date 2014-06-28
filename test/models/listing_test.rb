require 'test_helper'

class ListingTest < ActiveSupport::TestCase
  describe "create" do
    before do
      @user = Fabricate(:user)
    end

    it "should create with required attributes" do
      @listing = @user.listings.create!(title: "Title 1", price: 100)
    end

    it "should start in approved state" do
      @listing = @user.listings.create!(title: "Title 2", price: 100)
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

  describe "editable" do
    before do
      @user = Fabricate(:user)
      @listing = Fabricate(:listing, user: @user)
    end

    it "should be editable for 3 days after approval" do
      @listing.update_attributes(created_at: 71.hours.ago)
      @listing.editable?.must_equal true
      @listing.update_attributes(created_at: 73.hours.ago)
      @listing.editable?.must_equal false
    end
  end

  describe "shipping prices" do
    before do
      @user = Fabricate(:user)
      @listing = Fabricate(:listing, user: @user, price: 15000)
      @listing.shipping_prices = {'US' => '57.0', 'everywhere' => '120.50'}
      @listing.save
      @listing.reload
    end

    it "should calculate shipping price to location" do
      @listing.shipping_price(to: 'US').must_equal 5700
      @listing.shipping_price(to: 'everywhere').must_equal 12050
      @listing.shipping_price(to: 'local').must_equal 0
    end
  end

  describe "search" do
    before do
      @user = Fabricate(:user)
    end

    describe "by category name" do
      before do
        @lizards = Category.create!(name: 'Lizards')
        @geckos = Category.create!(name: 'Geckos')
        @listing1 = @user.listings.create!(title: "Lizard", price: 100)
        @listing1.categories.push(@lizards)
        @listing1.categories.push(@geckos)
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

    describe "by category id" do
      before do
        @lizards = Category.create!(name: 'Lizards')
        @listing1 = @user.listings.create!(title: "Lizard", price: 100)
        @listing1.categories.push(@lizards)
        Listing.import
        Listing.__elasticsearch__.refresh_index!
      end

      it "should find on category match" do
        @results = Listing.search(filter: {term: {category_ids: @lizards.id}})
        @results.size.must_equal 1
        @results = Listing.search(filter: {term: {category_ids: [@lizards.id]}})
        @results.size.must_equal 1
      end
    end

    describe "by state" do
      before do
        @listing1 = @user.listings.create!(title: "Lizard", price: 100)
        Listing.import
      end

      it "should find approved listings" do
        @listing1.state.must_equal 'approved'
        Listing.search('lizard').results.size.must_equal 1
      end

      it "should not find sold listings" do
        @listing1.sold!
        @listing1.reload
        @listing1.state.must_equal 'sold'
        Listing.__elasticsearch__.refresh_index!
        Listing.search('lizard').results.size.must_equal 0
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
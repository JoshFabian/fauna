require 'test_helper'

class ListingTest < ActiveSupport::TestCase
  before do
    @user = Fabricate(:user, listing_credits: 3)
  end

  describe "create" do
    it "should create with required attributes" do
      @listing = @user.listings.create!(title: "Title 1", price: 100)
    end

    it "should default facebook_share to 0" do
      @listing = @user.listings.new
      @listing.facebook_share.must_equal 0
    end

    it "should start in draft state" do
      @listing = @user.listings.create!(title: "Title 2", price: 100)
      @listing.state.must_equal 'draft'
    end

    it "should add user seller role" do
      @listing = @user.listings.create!(title: "Title 2", price: 100)
      @user.roles?(:seller).must_equal false
      @user.reload
      @user.roles?(:seller).must_equal true
    end

    describe "listing credits" do
      it "should decrement user listing_credits when credits gt 0" do
        @user.listing_credits.must_equal 3
        @listing = @user.listings.create!(title: "Title 2", price: 100)
        @user.reload
        @user.listing_credits.must_equal 2
      end

      it "should not decrement user listing_credits when credits lte 0" do
        @user.update_attributes(listing_credits: 0)
        @user.reload
        @user.listing_credits.must_equal 0
        @listing = @user.listings.create!(title: "Title 2", price: 100)
        @user.reload
        @user.listing_credits.must_equal 0
      end
    end

    describe "facebook share" do
      it "should set user.facebook_share_listing when listing.facebook_share is set" do
        @user.facebook_share_listing = 0; @user.save
        @user.facebook_share_listing.must_equal 0
        @listing = @user.listings.create!(title: "Title 2", price: 100, facebook_share: 1)
        @listing.facebook_share.to_i.must_equal 1
        @user.reload
        @user.facebook_share_listing.to_i.must_equal 1
      end
    end
  end

  describe "state machine" do
    before do
      @listing = Fabricate(:listing, user: @user, state: 'active')
    end

    it "should set flagged reason and timestamp on flag event" do
      @listing.state.must_equal 'active'
      @listing.flag_with_reason!(reason: "just cause")
      @listing.reload
      @listing.state.must_equal 'flagged'
      @listing.flagged_at.present?.must_equal true
      @listing.flagged_reason.must_equal 'just cause'
    end
  end

  describe "user breeder flag" do
    it "should set breeder flag when user has gte 3 active listings" do
      @user.breeder?.must_equal false
      1.upto(10).each { Fabricate(:listing, user: @user, state: 'active') }
      @user.reload
      @user.breeder?.must_equal true
    end
  end

  describe "user store flag" do
    it "should set store flag after 10 listings" do
      @user.store?.must_equal false
      1.upto(10).each { Fabricate(:listing, user: @user, state: 'active') }
      @user.reload
      @user.store?.must_equal true
    end
  end

  describe "slug" do
    it "should auto create slug from title" do
      @listing = Fabricate(:listing, user: @user, title: "Listing 1")
      @listing.slug.must_equal 'listing-1'
    end

    it "should change slug when title is changed" do
      @listing = Fabricate(:listing, user: @user, title: "Listing 1")
      @listing.update_attributes(title: "Tegu Lizard")
      @listing.reload
      @listing.slug.must_equal "tegu-lizard"
    end
  end

  describe "draft complete" do
    before do
      @listing = Fabricate(:listing, user: @user)
    end

    it "should return false when no images" do
      @listing.may_approve?.must_equal false
      @listing.draft_complete?.must_equal false
    end

    it "should return true with price, 1 image, 1 shipping from" do
      @listing.images.create!
      @listing.update(price: 100)
      @listing.may_approve?.must_equal true
      @listing.draft_complete?.must_equal true
    end
  end

  describe "editable" do
    before do
      @listing = Fabricate(:listing, user: @user)
    end

    it "should be editable in draft state" do
      @listing.state.must_equal 'draft'
      @listing.editable?.must_equal true
    end

    it "should be editable in active state for 3 days after approval" do
      @listing.update(state: 'active')
      @listing.update_attributes(created_at: 71.hours.ago)
      @listing.editable?.must_equal true
      @listing.update_attributes(created_at: 73.hours.ago)
      @listing.editable?.must_equal false
    end
  end

  describe "shipping prices" do
    before do
      @listing = Fabricate(:listing, user: @user, price: 15000)
      @listing.shipping_prices = {'US' => '57.0', 'everywhere' => '120.50', 'local' => '0'}
      @listing.save
      @listing.reload
    end

    it "should calculate shipping price to location" do
      @listing.shipping_price(to: 'US').must_equal 5700
      @listing.shipping_price(to: 'everywhere').must_equal 12050
      @listing.shipping_price(to: 'local').must_equal 0
    end
  end

  describe "likes" do
    before do
      @listing = Fabricate(:listing, user: @user)
    end

    it "should create like and increment listing.likes_count" do
      @listing.likes_count.must_equal 0
      ListingLike.like!(@listing, @user).must_equal true
      @listing.reload
      @listing.likes_count.must_equal 1
    end

    it "should create like and increment user.wall_likes_count" do
      @user.wall_likes_count.must_equal 0
      ListingLike.like!(@listing, @user).must_equal true
      @user.reload
      @user.wall_likes_count.must_equal 1
    end

    it "should remove like and decrement likes_count" do
      ListingLike.like!(@listing, @user).must_equal true
      ListingLike.unlike!(@listing, @user).must_equal true
      @listing.reload
      @listing.likes_count.must_equal 0
    end

    it "should toggle like and adjust likes_count" do
      @listing.likes_count.must_equal 0
      ListingLike.toggle_like!(@listing, @user).must_equal true
      @listing.reload
      @listing.likes_count.must_equal 1
      ListingLike.toggle_like!(@listing, @user).must_equal true
      @listing.reload
      @listing.likes_count.must_equal 0
    end

    it "should not allow duplicate like by user" do
      ListingLike.like!(@listing, @user).must_equal true
      ListingLike.like!(@listing, @user).must_equal false
      @listing.reload
      @listing.likes_count.must_equal 1
    end
  end

  describe "search" do
    describe "by category name" do
      before do
        Listing.delete_all
        Category.delete_all
        @lizards = Category.create!(name: 'Lizards')
        @geckos = Category.create!(name: 'Geckos')
        @listing1 = @user.listings.create!(title: "Lizard", price: 100, state: 'active')
        @listing1.categories.push(@lizards)
        @listing1.categories.push(@geckos)
        Listing.import(force: true)
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
        Category.delete_all
        @lizards = Category.create!(name: 'Lizards')
        @listing1 = @user.listings.create!(title: "Lizard", price: 100)
        @listing1.categories.push(@lizards)
        Listing.import(force: true)
        Listing.__elasticsearch__.refresh_index!
      end

      it "should find on category filter match" do
        results = Listing.search(filter: {term: {category_ids: @lizards.id}})
        results.size.must_equal 1
        results = Listing.search(filter: {term: {category_ids: [@lizards.id]}})
        results.size.must_equal 1
      end

      it "should find on category filter bool match" do
        results = Listing.search(filter: {bool: {must: {term: {category_ids: [@lizards.id]}}}})
        results.size.must_equal 1
      end

      it "should find on multiple term filter match" do
        terms = [{term: {category_ids: @lizards.id}}, {term: {user_id: @user.id}}]
        results = Listing.search(filter: {bool: {must: terms}})
        results.size.must_equal 1
      end

      it "should not find on multiple term filter match" do
        @dummy = Fabricate(:user, listing_credits: 3)
        listing2 = @dummy.listings.create!(title: "Dummy Listing", price: 100)
        Listing.search(filter: {bool: {must: [{term: {category_ids: @lizards.id}},
          {term: {user_id: @dummy.id}}]}}).results.size.must_equal 0
      end

      it "should find when listing category is changed" do
        @geckos = Category.create!(name: 'Geckos')
        @listing1.categories.destroy(@lizards)
        @listing1.categories.push(@geckos)
        @listing1.reload
        @listing1.categories.must_equal [@geckos]
        @listing1.should_update_index!
        Listing.__elasticsearch__.refresh_index!
        results = Listing.search(filter: {term: {category_ids: @geckos.id}})
        results.size.must_equal 1
      end
    end

    describe "by state" do
      before do
        Listing.delete_all
        @listing = @user.listings.create!(title: "Lizard", price: 100)
        Listing.import(force: true)
        Listing.__elasticsearch__.refresh_index!
      end

      it "should find listings in draft state" do
        @listing.state.must_equal 'draft'
        Listing.search(filter: {term: {state: 'draft'}}).results.size.must_equal 1
        Listing.search(filter: {term: {state: 'active'}}).results.size.must_equal 0
      end

      it "should find listings in active state" do
        @listing = flexmock(@listing, :draft_complete? => true)
        @listing.approve!
        @listing.state.must_equal 'active'
        Listing.__elasticsearch__.refresh_index!
        Listing.search(filter: {term: {state: 'active'}}).results.size.must_equal 1
        Listing.search(filter: {term: {state: 'draft'}}).results.size.must_equal 0
      end

      it "should find listings matching draft state and title" do
        Listing.search({query: {match: {title: 'lizard'}}, filter: {term: {state: 'draft'}}}).results.size.must_equal 1
      end

      it "should find listings in sold state" do
        @listing = flexmock(@listing, :draft_complete? => true)
        @listing.approve!
        @listing.sold!
        @listing.state.must_equal 'sold'
        Listing.__elasticsearch__.refresh_index!
        Listing.search(filter: {term: {state: 'sold'}}).results.size.must_equal 1
      end
    end

    describe "by title" do
      before do
        Listing.destroy_all
        @listing1 = @user.listings.create!(title: "Lizard", price: 100)
        @listing2 = @user.listings.create!(title: "Tegu", price: 100)
        Listing.import(force: true)
        Listing.__elasticsearch__.refresh_index!
      end

      it "should find with exact title match" do
        Listing.search('lizard').results.size.must_equal 1
        Listing.search('tegu').results.size.must_equal 1
      end

      it "should find with substring title match" do
        Listing.search('liz*').results.size.must_equal 1
        Listing.search('tegu*').results.size.must_equal 1
      end

      it "should not find when title doesn't match" do
        Listing.search('reptile').results.size.must_equal 0
      end
    end

    describe "by user handle" do
      before do
        @listing1 = @user.listings.create!(title: "1", price: 100)
        @listing2 = @user.listings.create!(title: "2", price: 100)
        Listing.import(force: true)
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
        Listing.search(filter: {term: {user_handle: "bogus"}}).results.size.must_equal 0
      end
    end

    describe "by user id" do
      before do
        @listing1 = @user.listings.create!(title: "1", price: 100)
        @listing2 = @user.listings.create!(title: "2", price: 100)
        Listing.import(force: true)
        Listing.__elasticsearch__.refresh_index!
      end

      it "should find with id match" do
        Listing.search(filter: {term: {user_id: @user.id}}).results.size.must_equal 2
      end

      it "should not find with invalid id" do
        Listing.search(filter: {term: {user_id: 0}}).results.size.must_equal 0
      end
    end
  end
end
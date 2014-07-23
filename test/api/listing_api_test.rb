require 'test_helper'

class ListingApiSpec < ActionDispatch::IntegrationTest
  describe "listing create" do
    before do
      Category.delete_all
      @user = Fabricate(:user, listing_credits: 3)
      @lizards = Category.create!(name: 'Lizards')
    end

    it "should create listing with category" do
      data = {listing: {title: "Listing", price: 5000, categories: [@lizards.id]}}
      post "/api/v1/listings?token=#{@user.auth_token}", data
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['listing'].must_include('title' => 'Listing', 'category_ids' => [@lizards.id])
      @lizards.reload
      @lizards.listings_count.must_equal 1
    end

    it "should not create listing" do
      data = {listing: {title: "Listing"}}
      post "/api/v1/listings?token=#{@user.auth_token}", data
      response.status.must_equal 400
    end
  end

  describe "listing event" do
    before do
      @user = Fabricate(:user, listing_credits: 3)
      @listing = @user.listings.create!(title: "Title", price: 100)
    end

    it "should mark listing as sold" do
      @listing.state.must_equal 'active'
      put "/api/v1/listings/#{@listing.id}/event/sold?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['listing'].must_include({'id' => @listing.id, 'state' => 'sold'})
      @listing.reload
      @listing.state.must_equal 'sold'
      @listing.sold_at.present?.must_equal true
    end
  end

  describe "listing review" do
    before do
      @user = Fabricate(:user, listing_credits: 3)
      @listing = @user.listings.create!(title: "Title", price: 100)
      @reviewer = Fabricate(:user)
    end

    it "should create review" do
      data = {review: {body: "body"}}
      post "/api/v1/listings/#{@listing.id}/reviews?token=#{@reviewer.auth_token}", data
      response.success?.must_equal true
      body = JSON.parse(response.body)
      review = @listing.reviews.first
      body['review'].must_include({'id' => review.id, 'body' => 'body'})
    end

    it "should create review with ratings" do
      data = {review: {body: "body"}, ratings: {communication: 3, description: 4}}
      post "/api/v1/listings/#{@listing.id}/reviews?token=#{@reviewer.auth_token}", data
      response.success?.must_equal true
      body = JSON.parse(response.body)
      review = @listing.reviews.first
      body['review'].must_include({'id' => review.id, 'body' => 'body'})
      body['review']['ratings'].must_include([{'name' => 'communication', 'rating' => 3.0},
        {'name' => 'description', 'rating' => 4.0}])
    end
  end

  describe "listing shipping price" do
    before do
      @user = Fabricate(:user, listing_credits: 3)
      @listing = @user.listings.create!(title: "Title", price: 10000)
      @listing.shipping_prices = {'US' => '57.0', 'international' => '120.50', 'local' => '5'}
      @listing.save
      @listing.reload
    end

    it "should get shipping price to US" do
      get "/api/v1/listings/#{@listing.id}/shipping/to/US?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['listing'].must_include('price' => 10000, 'shipping_price' => 5700, 'total_price' => 15700)
    end

    it "should get shipping price to international" do
      get "/api/v1/listings/#{@listing.id}/shipping/to/international?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['listing'].must_include('price' => 10000, 'shipping_price' => 12050, 'total_price' => 22050)
    end

    it "should get local pickup price" do
      get "/api/v1/listings/#{@listing.id}/shipping/to/local?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['listing'].must_include('price' => 10000, 'shipping_price' => 500, 'total_price' => 10500)
    end

    it "should not get shipping price to invalid location" do
      get "/api/v1/listings/#{@listing.id}/shipping/to/xxx?token=#{@user.auth_token}"
      response.status.must_equal 404
    end
  end

  describe "listing category update" do
    before do
      Category.delete_all
      @user = Fabricate(:user, listing_credits: 3)
      @listing = @user.listings.create!(title: "Title", price: 10000)
      @lizards = Category.create!(name: 'Lizards')
      @geckos = Category.create!(name: 'Geckos')
    end

    it "should add category to listing" do
      data = {listing: {categories: [@lizards.id]}}
      put "/api/v1/listings/#{@listing.id}?token=#{@user.auth_token}", data
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['listing'].must_include('category_ids' => [@lizards.id])
      @lizards.reload
      @lizards.listings_count.must_equal 1
    end

    it "should remove category from listing" do
      @listing.categories.push(@lizards)
      @lizards.should_update_listings_count!
      data = {listing: {categories: [@geckos.id]}}
      put "/api/v1/listings/#{@listing.id}?token=#{@user.auth_token}", data
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['listing'].must_include('category_ids' => [@geckos.id])
      @lizards.reload
      @geckos.reload
      @lizards.listings_count.must_equal 0
      @geckos.listings_count.must_equal 1
    end
  end
end
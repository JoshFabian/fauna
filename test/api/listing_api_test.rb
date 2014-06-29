require 'test_helper'

class ListingApiSpec < ActionDispatch::IntegrationTest
  describe "listing event" do
    before do
      @user = Fabricate(:user, listing_credits: 3)
      @listing = @user.listings.create!(title: "Title", price: 100)
    end

    it "should mark listing as sold" do
      @listing.state.must_equal 'approved'
      put "/api/v1/listings/#{@listing.id}/event/sold?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['listing'].must_include({'id' => @listing.id, 'state' => 'sold'})
      @listing.reload
      @listing.state.must_equal 'sold'
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
      @listing.shipping_prices = {'US' => '57.0', 'everywhere' => '120.50'}
      @listing.save
      @listing.reload
    end

    it "should get shipping price to US" do
      get "/api/v1/listings/#{@listing.id}/shipping/to/US?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['listing'].must_include('price' => 10000, 'shipping_price' => 5700, 'total_price' => 15700)
    end

    it "should get shipping price to everywhere" do
      get "/api/v1/listings/#{@listing.id}/shipping/to/everywhere?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['listing'].must_include('price' => 10000, 'shipping_price' => 12050, 'total_price' => 22050)
    end

    it "should get local pickup price" do
      get "/api/v1/listings/#{@listing.id}/shipping/to/local?token=#{@user.auth_token}"
      response.success?.must_equal true
      body = JSON.parse(response.body)
      body['listing'].must_include('price' => 10000, 'shipping_price' => 0, 'total_price' => 10000)
    end

    it "should not get shipping price to invalid location" do
      get "/api/v1/listings/#{@listing.id}/shipping/to/xxx?token=#{@user.auth_token}"
      response.status.must_equal 404
    end
  end
end
require 'test_helper'

class ListingApiSpec < ActionDispatch::IntegrationTest
  describe "listing event" do
    before do
      @user = Fabricate(:user)
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
end
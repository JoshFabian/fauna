require 'test_helper'

class ReportApiSpec < ActionDispatch::IntegrationTest
  describe "create report" do
    before do
      @user = Fabricate(:user, listing_credits: 3)
      @listing = @user.listings.create!(title: "Title", price: 100)
    end

    it "should create listing report" do
      @listing.reports.count.must_equal 0
      data = {report: {message: "message"}}
      post "/api/v1/reports/#{@listing.id}?token=#{@user.auth_token}", data
      response.success?.must_equal true
      body = JSON.parse(response.body)
      report = @listing.reports.first
      body['report'].must_include({'id' => report.id, 'listing_id' => @listing.id, 'user_id' => @user.id,
        'message' => 'message'})
    end

    it "should not create duplicate listing report" do
      @report = @listing.reports.create!(user: @user)
      post "/api/v1/reports/#{@listing.id}?token=#{@user.auth_token}"
      response.status.must_equal 400
    end
  end
end
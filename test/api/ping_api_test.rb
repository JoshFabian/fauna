require 'test_helper'

class PingApiSpec < ActionDispatch::IntegrationTest
  describe "GET /api/v1/ping" do
    it "should return pong" do
      get "/api/v1/ping"
      response.success?.must_equal true
      JSON.parse(response.body).must_equal ({'ping' => 'pong'})
    end
  end
end
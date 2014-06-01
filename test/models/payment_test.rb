require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  before do
    @buyer = Fabricate(:user)
    @seller = Fabricate(:user)
    @listing = @seller.listings.create!(title: "Title", price: 100)
  end

  describe "create" do
    it "should start in init state" do
      @payment = Payment.create!(listing: @listing, buyer: @buyer)
      @payment.state.must_equal 'init'
    end
  end

  describe "state machine" do
    it "should transition to exception state on error event" do
      @payment = Payment.create!(listing: @listing, buyer: @buyer)
      @payment.error_message = "this didn't work"
      @payment.error!
      @payment.reload
      @payment.state.must_equal 'exception'
      @payment.error_message.must_equal "this didn't work"
    end
  end
end
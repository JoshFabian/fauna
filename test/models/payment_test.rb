require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  before do
    @buyer = Fabricate(:user)
    @seller = Fabricate(:user)
    @listing = @seller.listings.create!(title: "Title", price: 100)
  end

  describe "payment create" do
    it "should start in init state" do
      @payment = Payment.create!(listing: @listing, buyer: @buyer)
      @payment.state.must_equal 'init'
    end
  end

  describe "payment state machine" do
    it "should transition to exception state on error event" do
      @payment = Payment.create!(listing: @listing, buyer: @buyer)
      @payment.error_message = "this didn't work"
      @payment.error!
      @payment.reload
      @payment.state.must_equal 'exception'
      @payment.error_message.must_equal "this didn't work"
    end

    it "should associate completed payments with buyer purchases" do
      @payment = Payment.create!(listing: @listing, buyer: @buyer)
      @buyer.payments.count.must_equal 1
      @buyer.purchases.count.must_equal 0
      @payment.complete!
      @buyer.purchases.count.must_equal 1
      @buyer.purchases.must_equal [@payment]
    end
  end

  describe "purchase reviews" do
    it "should allow buyer to review" do
      @payment = Payment.create!(listing: @listing, buyer: @buyer)
      @listing.review_allowed?(@buyer).must_equal false
      @payment.complete!
      @listing.review_allowed?(@buyer).must_equal true
      @listing.review_allowed?(@seller).must_equal false
    end

    it "should return true if buyer has reviewed purchase" do
      @review = @listing.reviews.create!(user: @buyer, body: "body")
      @listing.reviewed_by?(@buyer).must_equal true
    end

    it "should return false if buyer has not reviewed purchase" do
      @listing.reviewed_by?(@buyer).must_equal false
    end
  end
end
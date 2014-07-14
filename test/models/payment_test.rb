require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  before do
    @buyer = Fabricate(:user)
    @seller = Fabricate(:user, listing_credits: 3)
    @listing = @seller.listings.create!(title: "Title", price: 100)
    @mash = Hashie::Mash.new(buyer: @buyer, listing: @listing, listing_price: @listing.price, shipping_price: 1000,
      shipping_to: 'US')
  end

  describe "payment create" do
    it "should start in init state" do
      @payment = Payment.create!(@mash)
      @payment.state.must_equal 'init'
    end

    it "should default reviewed to false" do
      @payment = Payment.create!(@mash)
      @payment.reviewed?.must_equal false
    end
  end

  describe "payment state machine" do
    it "should transition to exception state on error event" do
      @payment = Payment.create!(@mash)
      @payment.error_message = "this didn't work"
      @payment.error!
      @payment.reload
      @payment.state.must_equal 'exception'
      @payment.error_message.must_equal "this didn't work"
    end

    it "should associate completed payments with buyer purchases" do
      @payment = Payment.create!(@mash)
      @buyer.payments.count.must_equal 1
      @buyer.purchases.count.must_equal 0
      @payment.complete!
      @payment.reload
      @payment.state.must_equal 'completed'
      @buyer.purchases.count.must_equal 1
      @buyer.purchases.must_equal [@payment]
    end
  end

  describe "payment conversation" do
    it "should start conversation between buyer and seller after payment completed" do
      @payment = Payment.create!(@mash)
      @payment.complete!
      @conversation = @payment.start_buyer_conversation!
      @conversation.persisted?.must_equal true
      @payment.start_buyer_conversation!.must_equal nil
    end
  end

  describe "purchase reviews" do
    before do
      @payment = Payment.create!(@mash)
      @payment.complete!
    end

    it "should allow buyer to review after 24 hours" do
      @payment.update_attributes!(completed_at: 23.hours.ago)
      @listing.review_allowed?(@buyer).must_equal false
      @listing.review_allowed?(@seller).must_equal false
      @payment.update_attributes!(completed_at: 25.hours.ago)
      @listing.review_allowed?(@buyer).must_equal true
      @listing.review_allowed?(@seller).must_equal false
    end

    it "should return true if buyer has reviewed purchase" do
      @review = @listing.reviews.create!(user: @buyer, body: "body")
      @listing.reviewed_by?(@buyer).must_equal true
    end

    it "should set payment reviewed flag after buyer reviews purchase" do
      @payment.reviewed?.must_equal false
      @review = @listing.reviews.create!(user: @buyer, body: "body")
      @payment.reload
      @payment.reviewed?.must_equal true
    end

    it "should return false if buyer has not reviewed purchase" do
      @listing.reviewed_by?(@buyer).must_equal false
    end

    it "should set buyer pending_listing_reviews when purchase has not been reviewed after 5 days" do
      @payment.update_attributes!(completed_at: 4.days.ago)
      ReviewJob.perform({})
      @buyer.reload
      @buyer.pending_listing_reviews.must_equal 0
      @payment.update_attributes!(completed_at: 6.days.ago)
      ReviewJob.perform({})
      @buyer.reload
      @buyer.pending_listing_reviews.must_equal 1
      ReviewJob.perform({})
      @buyer.reload
      @buyer.pending_listing_reviews.must_equal 1
    end

    it "should reset buyer pending_listing_reviews after purchase is reviewed" do
      @payment.update_attributes!(completed_at: 6.days.ago)
      @buyer.update_attributes(pending_listing_reviews: 1)
      @buyer.pending_listing_reviews.must_equal 1
      @review = @listing.reviews.create!(user: @buyer, body: "body")
      ReviewJob.perform({})
      @buyer.reload
      @buyer.pending_listing_reviews.must_equal 0
    end
  end
end
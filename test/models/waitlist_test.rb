require 'test_helper'

class WaitlistTest < ActiveSupport::TestCase
  describe "create" do
    it "should create with required attributes" do
      @waitlist = Waitlist.create!(email: "user@gmail.com")
    end

    it "should auto create invite code" do
      @waitlist = Waitlist.create!(email: "user@gmail.com")
      @waitlist.code.present?.must_equal true
    end

    it "should validate email" do
      @waitlist = Waitlist.create(email: "foo")
      @waitlist.valid?.must_equal false
    end
  end

  describe "signups" do
    it "should increment signup count when user invites another user" do
      @waitlist1 = Waitlist.create!(email: "user1@gmail.com")
      @waitlist1.signup_count.must_equal 0
      @waitlist2 = Waitlist.create!(email: "user2@gmail.com", referer: @waitlist1.code)
      @waitlist1.reload
      @waitlist1.signup_count.must_equal 1
    end
  end
end
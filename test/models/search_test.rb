require 'test_helper'

class SearchTest < ActiveSupport::TestCase

  describe "wildcard" do
    it "should create query from single term" do
      Search.wildcard_query("boo").must_equal "boo*"
    end

    it "should create query from multiple words" do
      Search.wildcard_query("ball python").must_equal "ball* python*"
    end

    it "should not change query with -" do
      Search.wildcard_query("boo-stuff").must_equal "boo-stuff"
    end

    it "should not change query with *" do
      Search.wildcard_query("boo*").must_equal "boo*"
    end
  end
end
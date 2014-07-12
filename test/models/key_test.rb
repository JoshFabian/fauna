require 'test_helper'

class KeyTest < ActiveSupport::TestCase
  describe "create" do
    it "should create key" do
      Key.create!(env: Rails.env, name: 'cloudinary', value: 'key1')
    end

    it "should not create another key for same [env,name] tuple" do
      Key.create!(env: 'development', name: 'cloudinary', value: 'key1')
      Key.create(env: 'development', name: 'cloudinary', value: 'key2').valid?.must_equal false
      Key.create!(env: 'development', name: 'twilio', value: 'key1')
    end
  end

  describe "get" do
    before do
      Key.create!(env: Rails.env, name: 'cloudinary', value: 'cloud1')
    end

    it "should get key value with env specified" do
      Key.get_value(env: Rails.env, name: 'cloudinary').must_equal 'cloud1'
    end

    it "should get key value for current env" do
      Key.get_value(name: 'cloudinary').must_equal 'cloud1'
    end

    it "should get key value with symbol" do
      Key.get_value(name: :cloudinary).must_equal 'cloud1'
    end

    it "should get key names for current env" do
      Key.get_names.must_equal ['cloudinary']
    end
  end
end
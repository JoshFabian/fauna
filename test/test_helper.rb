ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'database_cleaner'
require 'minitest/rails'
require 'minitest/focus'
require 'minitest/colorize'
require 'flexmock/test_unit'

DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  before :each do
    Category.delete_all
    DatabaseCleaner.start
    # ElasticIndex.delete_all
    # ElasticIndex.create_all
  end

  after :each do
    DatabaseCleaner.clean
  end
end

module MiniTest
  module Assertions
    def assert_includes collection, obj, msg = nil
      msg = message(msg) {
        "Expected #{mu_pp(collection)} to include #{mu_pp(obj)}"
      }
      assert_respond_to collection, :include?
      if obj.is_a?(Hash)
        # select keys from collection and compare
        assert_equal collection.select{ |k,v| obj.keys.include?(k) }, obj
      elsif obj.is_a?(Array) and obj.all?{ |o| o.is_a?(Hash) }
        # select keys from each hash in collection and compare
        assert_equal collection.map{ |hash| hash.select{ |k,v| obj.first.keys.include?(k) }}, obj
      else
        # default behavior
        assert collection.include?(obj), msg
      end
    end
  end # assertions
end # minitest
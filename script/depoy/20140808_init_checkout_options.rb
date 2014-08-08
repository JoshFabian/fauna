#!/usr/bin/env ruby
require File.expand_path(File.join(File.dirname(__FILE__), '../..', 'config', 'environment'))

puts "#{Time.now}: initialize listing checkout options"

count = 0

Listing.find_each do |listing|
  next if listing.draft? or listing.checkout_option.present?
  listing.checkout_option = 'paypal'
  listing.save
  count += 1
end

puts "#{Time.now}: initialized #{count} listings"
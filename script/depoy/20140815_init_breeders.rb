#!/usr/bin/env ruby
require File.expand_path(File.join(File.dirname(__FILE__), '../..', 'config', 'environment'))

puts "#{Time.now}: initialize breeders"

count = 0

User.find_each do |user|
  begin
    next if user.listings.active.count < 3
    user.update(breeder: true)
    count += 1
  rescue => e
  end
end

puts "#{Time.now}: initialized #{count} breeders"
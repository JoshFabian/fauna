#!/usr/bin/env ruby
require File.expand_path(File.join(File.dirname(__FILE__), '../..', 'config', 'environment'))

puts "#{Time.now}: update users"

count = 0

User.find_each do |user|
  begin
    user.trial_ends_at = 30.days.from_now
    user.save
    count += 1
  rescue => e
  end
end

puts "#{Time.now}: updated #{count} users"
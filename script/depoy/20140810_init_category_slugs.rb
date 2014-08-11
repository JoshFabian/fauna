#!/usr/bin/env ruby
require File.expand_path(File.join(File.dirname(__FILE__), '../..', 'config', 'environment'))

puts "#{Time.now}: initialize category slugs"

count = 0

Category.find_each do |category|
  begin
    category.save
    count += 1
  rescue => e
    
  end
end

puts "#{Time.now}: initialized #{count} categories"
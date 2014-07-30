#!/usr/bin/env ruby
require File.expand_path(File.join(File.dirname(__FILE__), '../..', 'config', 'environment'))

puts "#{Time.now}: sending first buyer email to waitlist members marked as buyers"

count = 0

Waitlist.where(role: 'buyer').each do |waitlist|
  begin
    WaitlistMailer.first_buyer_email(waitlist.email, subject: "You're invited to Fauna").deliver
    count += 1
  rescue Exception => e
  end
end

puts "#{Time.now}: sent #{count} emails"
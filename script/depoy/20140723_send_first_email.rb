#!/usr/bin/env ruby
require File.expand_path(File.join(File.dirname(__FILE__), '../..', 'config', 'environment'))

puts "#{Time.now}: sending first email to waitlists members marked as both"

count = 0

Waitlist.where(role: 'both').each do |waitlist|
  begin
    WaitlistMailer.first_email(email: waitlist.email).deliver
    count += 1
  rescue Exception => e
    
  end
end

puts "#{Time.now}: sent #{count} emails"
class ListingFlaggedEmailJob
  include Backburner::Queue
  include Loggy
  queue "emails"  # defaults to 'backburner-jobs' tube
  queue_priority 1000 # most urgent priority is 0
  queue_respond_timeout 100 # number of seconds before job times out

  def self.perform(hash)
    listing = Listing.find_by_id(hash['id'] || hash['listing_id'])
    ListingMailer.listing_flagged_email(listing).deliver
    true
  rescue Exception => e
    false
  end

end
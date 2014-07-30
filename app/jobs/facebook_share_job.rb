class FacebookShareJob
  include Backburner::Queue
  include Loggy
  queue "share"  # defaults to 'backburner-jobs' tube
  queue_priority 1000 # most urgent priority is 0
  queue_respond_timeout 100 # number of seconds before job times out

  def self.perform(hash)
    if hash['klass'] == 'listing'
      listing = Listing.find(hash['id'])
      raise Exception, "listing already facebook shared" if listing.facebook_shared?
      ListingShare.facebook_share!(listing)
      logger.post("tegu.job", log_data.merge({event: 'facebook_share', listing_id: listing.id}))
    elsif hash['klass'] == 'post'
      post = Post.find(hash['id'])
      raise Exception, "post already facebook shared" if post.facebook_shared?
      PostShare.facebook_share!(post)
      logger.post("tegu.job", log_data.merge({event: 'facebook_share', post_id: post.id}))
    end
    1
  rescue Exception => e
    logger.post("tegu.job", log_data.merge({event: 'facebook_share.exception', message: e.message}))
    0
  end

end
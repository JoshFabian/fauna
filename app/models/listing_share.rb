class ListingShare
  include Loggy

  # returns true if the listing can be shared by the specified user
  def self.facebook_shareable?(listing, options={})
    user = options[:by] || listing.user
    user.facebook_share_permission?
  rescue Exception => e
    false
  end

  # returns true if the listing has been shared by the owner
  def self.facebook_shared?(listing, options={})
    listing.facebook_shared?
  end

  # returns true or exception
  def self.facebook_share!(listing, options={})
    user = options[:by] || listing.user
    graph = Koala::Facebook::API.new(user.facebook_oauth.oauth_token)
    message = options[:message] || listing.title
    link = options[:link] || "#{Settings[Rails.env][:api_host]}/#{listing.user.handle}/listings/#{listing.slug}"
    result = graph.put_connections('me', 'feed', message: message, link: link)
    listing.update(facebook_share_id: result['id'])
    # track event
    SegmentListing.track_listing_share(listing)
    true
  # rescue => e
    # if e.is_a?(Koala::Facebook::ClientError) and e.fb_error_type == "OAuthException"
    #   # invalid permissions
    # end
  end
end
class ListingConversation

  def self.find_listing(conversation_id)
    Listing.active.first
  end

end
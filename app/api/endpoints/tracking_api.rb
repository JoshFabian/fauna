module Endpoints
  class TrackingApi < Grape::API
    format :json

    rescue_from :all do |e|
      rack_response({status: "error", error: e.message})
    end

    resource :track do
      after_validation do
        authenticate!
      end

      desc "Track listing view"
      put 'listings/:id/view' do
        listing = Listing.find(params.id)
        SegmentListing.track_listing_viewed(listing, by: current_user)
        {tracking: 1}
      end
    end
  end
end
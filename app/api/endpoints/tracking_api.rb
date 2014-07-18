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
        SegmentListing.track_listing_view(listing, by: current_user)
        {tracking: 1}
      end

      desc "Track category view"
      put 'categories/:id/view' do
        category = Category.find(params.id)
        SegmentListing.track_category_view(category, by: current_user)
        {tracking: 1}
      end

      desc "Track user profile view"
      put 'users/:id/profile/view' do
        user = User.find(params.id)
        SegmentUser.track_profile_view(user, by: current_user)
        {tracking: 1}
      end
    end
  end
end
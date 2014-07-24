module Endpoints
  class TrackingApi < Grape::API
    format :json

    rescue_from :all do |e|
      rack_response({status: "error", error: e.message})
    end

    resource :track do
      helpers do
        def current_object
          current_user or current_session
        end
      end

      desc "Track listing view"
      put 'listings/:id/view' do
        listing = Listing.find(params.id)
        TrackObject.listing_view!(listing, by: current_object)
        SegmentListing.track_listing_view(listing, by: current_object)
        {tracking: 1}
      end

      desc "Track category view"
      put 'categories/:id/view' do
        category = Category.find(params.id)
        SegmentListing.track_category_view(category, by: current_object)
        {tracking: 1}
      end

      desc "Track user profile view"
      put 'users/:id/profile/view' do
        user = User.find(params.id)
        TrackObject.profile_view!(user, by: current_object)
        SegmentUser.track_profile_view(user, by: current_object)
        {tracking: 1}
      end
    end
  end
end
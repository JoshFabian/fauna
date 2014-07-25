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

      desc "Track listing peeks"
      put 'listings/:ids/peek' do
        ids = params.ids.split(',')
        ids.each do |id|
          listing = Listing.find(id)
          TrackObject.listing_peek!(listing, by: current_object)
        end
        {tracking: ids.size}
      end

      desc "Track listing views"
      put 'listings/:ids/view' do
        ids = params.ids.split(',')
        ids.each do |id|
          listing = Listing.find(id)
          TrackObject.listing_view!(listing, by: current_object)
          SegmentListing.track_listing_view(listing, by: current_object)
        end
        {tracking: ids.size}
      end

      desc "Track category views"
      put 'categories/:ids/view' do
        ids = params.ids.split(',')
        ids.each do |id|
          category = Category.find(id)
          SegmentListing.track_category_view(category, by: current_object)
        end
        {tracking: ids.size}
      end

      desc "Track user profile views"
      put 'users/:ids/profile/view' do
        ids = params.ids.split(',')
        ids.each do |id|
          user = User.find(params.id)
          TrackObject.profile_view!(user, by: current_object)
          SegmentUser.track_profile_view(user, by: current_object)
        end
        {tracking: ids.size}
      end
    end
  end
end
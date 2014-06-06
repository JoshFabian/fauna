module Endpoints
  class ListingApi < Grape::API
    format :json

    rescue_from :all do |e|
      rack_response({status: "error", error: e.message})
    end

    resource :listings do
      helpers do
        def listing_params
          ActionController::Parameters.new(params).require(:listing).permit(:description, :price, :title)
        end

        def listing_image_params(hash)
          ActionController::Parameters.new(hash).permit(:bytes, :etag, :format, :height, :position, :public_id,
            :resource_type, :version, :width)
        end
      end

      desc "Create listing"
      post '' do
        @listing = current_user.listings.create(listing_params)
        if params.image_params.present?
          params.image_params.each do |s|
            begin
              @listing.images.create(listing_image_params(JSON.parse(s)))
            rescue Exception => e
            end
          end
        end
        if params.listing.categories.present?
          new_categories = params.listing.categories.select{ |s| s.present? }.map(&:to_i)
          cur_categories = @listing.categories.collect(&:id)
          add_categories = new_categories - cur_categories
          del_categories = (cur_categories - new_categories)
          # add categories
          add_categories.each do |category_id|
            @listing.categories.push(Category.find_by_id(category_id))
          end
          # delete categories
          del_categories.each do |category_id|
            @listing.categories.delete(category_id)
          end
        end
        {listing: @listing}
      end

      desc "Update listing"
      put ':id' do
        @listing = current_user.listings.find(params[:id])
        @listing.update(listing_params)
        if params.image_params.present?
          params.image_params.each do |s|
            begin
              @listing.images.create(listing_image_params(JSON.parse(s)))
            rescue Exception => e
            end
          end
        end
        if params.listing.categories.present?
          new_categories = params.listing.categories.select{ |s| s.present? }.map(&:to_i)
          cur_categories = @listing.categories.collect(&:id)
          add_categories = new_categories - cur_categories
          del_categories = (cur_categories - new_categories)
          # add categories
          add_categories.each do |category_id|
            @listing.categories.push(Category.find_by_id(category_id))
          end
          # delete categories
          del_categories.each do |category_id|
            @listing.categories.delete(category_id)
          end
        end
        {listing: @listing}
      end

      desc "Change listing state"
      put ':id/event/:event' do
        @listing = current_user.listings.find(params[:id])
        begin
          @listing.send("#{params.event}")
          @listing.save
        rescue Exception => e
          
        end
        {listing: @listing}
      end

      desc "Get listing route"
      get ':id/show/route' do
        listing = Listing.find(params[:id])
        route = Rails.application.routes.url_helpers.user_listing_path(listing.user, listing)
        {route: route}
      end
    end
  end
end
module Endpoints
  class ListingApi < Grape::API
    format :json

    rescue_from :all do |e|
      rack_response({status: "error", error: e.message})
    end

    resource :listings do
      helpers do
        def listing_params
          ActionController::Parameters.new(params).require(:listing).permit(:description, :price, :shipping_from,
            :shipping_time, :title).tap do |whitelisted|
              whitelisted[:shipping_prices] = params[:listing][:shipping_prices]
          end
        end

        def listing_image_params(hash)
          ActionController::Parameters.new(hash).permit(:bytes, :etag, :format, :height, :position, :public_id,
            :resource_type, :version, :width)
        end

        def review_params
          ActionController::Parameters.new(params).require(:review).permit(:body, :user_id)
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
        logger.post("tegu.api", log_data.merge({event: 'listing.create', listing_id: @listing.id}))
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
        logger.post("tegu.api", log_data.merge({event: 'listing.update', listing_id: @listing.id}))
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
        logger.post("tegu.api", log_data.merge({event: 'listing.event', listing_id: @listing.id,
          event: params.event}))
        {listing: @listing}
      end

      desc "Delete listing image"
      delete ':listing_id/images/:id' do
        @listing = current_user.listings.find(params.listing_id)
        @image = @listing.images.find(params.id)
        @listing.images.destroy(@image)
        {listing: @listing.as_json(), event: 'delete'}
      end

      desc "Create listing review"
      post ':id/reviews' do
        authenticate!
        @listing = Listing.find(params.id)
        @review = @listing.reviews.create(review_params.merge(user: current_user))
        error!('401 Unauthorized', 401) if !@review.persisted?
        if params.ratings and params.ratings.is_a?(Hash)
          params.ratings.each_pair do |name,rating|
            @review.ratings.create(name: name, rating: rating)
          end
        end
        logger.post("tegu.api", log_data.merge({event: 'listing.review', listing_id: @listing.id}))
        {review: @review.as_json().merge(ratings: @review.ratings)}
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
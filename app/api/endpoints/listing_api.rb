module Endpoints
  class ListingApi < Grape::API
    format :json

    rescue_from :all do |e|
      rack_response({status: "error", error: e.message})
    end

    resource :listings do
      before do
        @listing = Listing.find(params[:id]) if params[:id].present?
      end

      helpers do
        def comment_params
          ActionController::Parameters.new(params).required(:comment).permit(:body)
        end

        def listing_params
          ActionController::Parameters.new(params).require(:listing).permit(:description, :local_pickup,
            :price, :shipping_from, :shipping_time, :title).tap do |whitelisted|
              whitelisted[:shipping_prices] = params[:listing][:shipping_prices]
          end
        end

        def listing_image_params(hash)
          ActionController::Parameters.new(hash).permit(:bytes, :crop_h, :crop_w, :crop_x, :crop_y, :etag, :format,
            :height, :position, :public_id, :resource_type, :version, :width)
        end

        def review_params
          ActionController::Parameters.new(params).require(:review).permit(:body, :user_id)
        end
      end

      desc "Get listing"
      get ':id' do
        logger.post("tegu.api", log_data.merge({event: 'listing.get', listing_id: @listing.id}))
        {listing: @listing}
      end

      desc "Create listing"
      post '' do
        @listing = current_user.listings.create(listing_params)
        if !@listing.persisted?
          logger.post("tegu.api", log_data.merge({event: 'listing.create.exception', errors: @listing.errors.full_messages}))
          error!("400 #{@listing.errors.full_messages.join(",")}", 400)
        end
        if params.listing.categories.present?
          new_categories = params.listing.categories.select{ |s| s.present? }.map(&:to_i)
          cur_categories = @listing.categories.collect(&:id)
          add_categories = new_categories - cur_categories
          del_categories = (cur_categories - new_categories)
          # add categories
          add_categories.each do |category_id|
            category = Category.find_by_id(category_id)
            next if category.blank?
            @listing.categories.push(category)
            category.should_update_listings_count!
          end
          # delete categories
          del_categories.each do |category_id|
            category = Category.find_by_id(category_id)
            next if category.blank?
            @listing.categories.destroy(category)
            category.should_update_listings_count!
          end
        end
        @listing.should_update_index!
        logger.post("tegu.api", log_data.merge({event: 'listing.create', listing_id: @listing.id}))
        {listing: @listing}
      end

      desc "Update listing"
      put ':id' do
        acl_manage!(on: @listing)
        # update listing
        @listing.update(listing_params)
        # check listing categories
        if params.listing.categories.present?
          begin
            new_categories = params.listing.categories.select{ |s| s.present? }.map(&:to_i)
            cur_categories = @listing.categories.pluck(:id)
            add_categories = new_categories - cur_categories
            del_categories = cur_categories - new_categories
            # add categories
            add_categories.each do |category_id|
              category = Category.find_by_id(category_id)
              next if category.blank?
              @listing.categories.push(category)
              category.should_update_listings_count!
            end
            # remove categories
            del_categories.each do |category_id|
              category = Category.find_by_id(category_id)
              next if category.blank?
              @listing.categories.destroy(category)
              category.should_update_listings_count!
            end
          rescue Exception => e
            logger.post("tegu.api", log_data.merge({event: 'listing.update.exception', message: e.message}))
          end
        end
        @listing.should_update_index!
        logger.post("tegu.api", log_data.merge({event: 'listing.update', listing_id: @listing.id}))
        {listing: @listing}
      end

      desc "Create listing images"
      post ':id/images' do
        acl_manage!(on: @listing)
        if params.image_params.present?
          params.image_params.each_pair do |id, hash|
            begin
              next if hash.blank?
              # create image
              hash = JSON.parse(hash) if hash.is_a?(String)
              @listing.images.create(listing_image_params(hash))
            rescue Exception => e
              logger.post("tegu.api", log_data.merge({event: 'listing.images.create.exception', message: e.message}))
            end
          end
        end
        logger.post("tegu.api", log_data.merge({event: 'listing.images.create', listing_id: @listing.id}))
        {listing: @listing}
      end

      desc "Update listing images"
      put ':id/images' do
        acl_manage!(on: @listing)
        if params.images.present?
            params.images.each_pair do |id, hash|
              begin
                next if id.blank? or hash.blank? or (image = @listing.images.find_by_id(id)).blank?
                # update image
                hash = JSON.parse(hash) if hash.is_a?(String)
                image.update(listing_image_params(hash))
                logger.post("tegu.api", log_data_min.merge({image_id: image.id, hash: hash}))
              rescue Exception => e
                logger.post("tegu.api", log_data.merge({event: 'listing.images.update.exception', message: e.message}))
              end
            end
        end
        @listing.should_update_index!
        logger.post("tegu.api", log_data.merge({event: 'listing.images.update', listing_id: @listing.id}))
        {listing: @listing}
      end

      desc "Flag listing"
      put ':id/flag' do
        acl_admin!
        @listing.flag_with_reason!(reason: params.reason)
        {listing: @listing.as_json(methods: [:flagged_reason])}
      end

      desc "Change listing state"
      put ':id/event/:event' do
        acl_manage!(on: @listing)
        acl_admin! if params.event.match(/flag/)
        begin
          @listing.send("#{params.event}")
          @listing.save
          if params.event.match(/remove/)
            SegmentListing.track_listing_remove(@listing)
          end
          @listing.should_update_index!
        rescue Exception => e
        end
        logger.post("tegu.api", log_data.merge({event: 'listing.event', listing_id: @listing.id,
          event: params.event}))
        {listing: @listing}
      end

      desc "Delete listing image"
      delete ':id/images/:image_id' do
        acl_manage!(on: @listing)
        image = @listing.images.find(params.image_id)
        @listing.images.destroy(image)
        logger.post("tegu.api", log_data.merge({event: 'listing.image.delete', listing_id: @listing.id,
          image_id: image.id}))
        {listing: @listing, event: 'delete'}
      end

      desc "Create listing comment"
      post ':id/comments' do
        authenticate!
        comment = current_user.comments.create(comment_params.merge(commentable: @listing))
        logger.post("tegu.api", log_data.merge({event: 'listing.comment.create', listing_id: @listing.id}))
        {listing: @listing.as_json().merge(comment: comment)}
      end

      desc "Toggle listing like"
      put ':id/toggle_like' do
        authenticate!
        ListingLike.toggle_like!(@listing, current_user)
        logger.post("tegu.api", log_data.merge({event: 'listing.toggle_like', listing_id: @listing.id}))
        {listing: @listing.as_json()}
      end

      desc "Create listing review"
      post ':id/reviews' do
        authenticate!
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

      desc "Get listing shipping price"
      get ':id/shipping/to/:country_code' do
        begin
          @shipping_price = @listing.shipping_price(to: params.country_code)
          @total_price = @listing.price + @shipping_price
          @shipping_price_string = ActionController::Base.helpers.number_to_currency(@shipping_price/100.0)
          @total_price_string = ActionController::Base.helpers.number_to_currency(@total_price/100.0)
        rescue Exception => e
          error!('Not Found', 404)
        end
        logger.post("tegu.api", log_data.merge({event: 'listing.shipping_price', listing_id: @listing.id}))
        {listing: {id: @listing.id, price: @listing.price, shipping_price: @shipping_price, total_price: @total_price,
          shipping_price_string: @shipping_price_string, total_price_string: @total_price_string}}
      end

      desc "Share listing on facebook"
      put ':id/share/facebook' do
        acl_manage!(on: @listing)
        begin
          graph = Koala::Facebook::API.new(current_user.facebook_oauth.oauth_token)
          message = params.message || @listing.title
          link = "#{Settings[Rails.env][:api_host]}/#{@listing.user.handle}/listings/#{@listing.slug}"
          result = graph.put_connections('me', 'feed', message: message, link: link)
          event = 'share'
          @listing.update(facebook_share_id: result['id'])
          logger.post("tegu.api", log_data.merge({event: 'listing.share.facebook', listing_id: @listing.id,
            result: result}))
        rescue Exception => e
          error!("Share exception: #{e.message}", 401)
        end
        {listing: @listing.as_json(methods: [:facebook_share_id]), event: event}
      end
    end
  end
end
module Endpoints
  class ImageApi < Grape::API
    format :json

    rescue_from :all do |e|
      rack_response({status: "error", error: e.message})
    end

    resource :images do
      helpers do
        def image_params
          ActionController::Parameters.new(params).require(:image).permit(:bytes, :crop_h, :crop_w, :crop_x, :crop_y,
            :etag, :format, :height, :position, :public_id, :resource_type, :version, :width)
        end
      end

      desc "Update listing image"
      put ':id' do
        image = ListingImage.find(params.id)
        listing = image.listing
        image.update(image_params)
        logger.post("tegu.api", log_data.merge({event: 'image.update', image_id: image.id}))
        {image: image}
      end
    end # images
  end
end
class ListingModalsController < ApplicationController

  # GET /listing_modals/crop_image?image_id=1&image_url=
  def crop_image
    @image_id = params[:image_id]
    @image_url = params[:image_url]

    respond_to do |format|
      format.js
    end
  end

end
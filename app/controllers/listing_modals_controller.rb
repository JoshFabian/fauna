class ListingModalsController < ApplicationController

  # GET /listing_modals/1/image_crop
  def image_crop
    @image = ListingImage.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

end
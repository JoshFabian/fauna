class ListingFormsController < ApplicationController

  # GET /listing_forms/new_image
  def new_image

    respond_to do |format|
      format.js
    end
  end

end
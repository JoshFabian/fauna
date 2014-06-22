class ListingFormsController < ApplicationController

  # GET /listing_forms/new_image
  def new_image

    respond_to do |format|
      format.js
    end
  end

  # GET /listing_forms/1/images
  def images
    @listing = Listing.find(params[:id])
    @images = @listing.images.order("position asc")

    respond_to do |format|
      format.js
    end
  end

  # GET /listing_forms/subcategories?id=1
  def subcategories
    @category = Category.find(params[:id])
    @categories = @category.children rescue []
    @prompt = "Reptile Sub-Category"

    respond_to do |format|
      format.js
    end
  end

end
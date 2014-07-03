class ListingFormsController < ApplicationController
  include Carmen

  # GET /listing_forms/1/images
  def images
    @listing = Listing.find(params[:id])
    @images = @listing.images.order("position asc")

    respond_to do |format|
      format.js
    end
  end

  # GET /listing_forms/new_image
  def new_image
    @listing = Listing.new

    respond_to do |format|
      format.js
    end
  end

  # GET /listing_forms/1/shipping_table?shipping_from=US
  def shipping_table
    begin
      @listing = Listing.find(params[:id])
      @shipping_prices = @listing.shipping_prices
    rescue Exception => e
      @shipping_prices = {}
    end

    @countries = []
    @countries.push(Country.coded(params[:shipping_from] || @listing.shipping_from))

    respond_to do |format|
      format.js
    end
  end

  # GET /listing_forms/subcategories?id=1
  def subcategories
    @listing = Listing.new
    @category = Category.find(params[:id])
    @categories = @category.children rescue []
    @prompt = "Reptile Sub-Category"

    respond_to do |format|
      format.js
    end
  end

end